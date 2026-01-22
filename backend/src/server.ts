import cors from "cors";
import express from "express";
import morgan from "morgan";
import { PrismaClient, CrowdLevel } from "@prisma/client";
import { z } from "zod";

const prisma = new PrismaClient();
const app = express();

app.use(cors());
app.use(express.json());
app.use(morgan("dev"));

app.get("/health", (_req, res) => {
  res.json({ status: "ok" });
});

app.get("/bars", async (_req, res) => {
  const bars = await prisma.bar.findMany({
    orderBy: { busyPercent: "desc" }
  });
  res.json(bars);
});

app.get("/bars/:id", async (req, res) => {
  const bar = await prisma.bar.findUnique({
    where: { id: req.params.id },
    include: { checkIns: { orderBy: { createdAt: "desc" }, take: 5 } }
  });

  if (!bar) {
    res.status(404).json({ error: "Bar not found" });
    return;
  }

  res.json(bar);
});

const checkInSchema = z.object({
  barId: z.string(),
  crowdLevel: z.nativeEnum(CrowdLevel),
  observations: z.array(z.string()).default([])
});

app.post("/checkins", async (req, res) => {
  const result = checkInSchema.safeParse(req.body);

  if (!result.success) {
    res.status(400).json({ error: result.error.flatten() });
    return;
  }

  const checkIn = await prisma.checkIn.create({
    data: {
      barId: result.data.barId,
      crowdLevel: result.data.crowdLevel,
      observations: result.data.observations
    }
  });

  res.status(201).json(checkIn);
});

app.get("/live", async (_req, res) => {
  const checkIns = await prisma.checkIn.findMany({
    orderBy: { createdAt: "desc" },
    take: 20,
    include: { bar: true }
  });

  res.json(checkIns);
});

app.get("/bars/:id/trend", async (req, res) => {
  const hours = Number(req.query.hours ?? 3);
  const since = new Date(Date.now() - hours * 60 * 60 * 1000);

  const checkIns = await prisma.checkIn.findMany({
    where: {
      barId: req.params.id,
      createdAt: { gte: since }
    },
    orderBy: { createdAt: "asc" }
  });

  res.json({
    barId: req.params.id,
    hours,
    points: checkIns.map((checkIn) => ({
      crowdLevel: checkIn.crowdLevel,
      createdAt: checkIn.createdAt
    }))
  });
});

const port = process.env.PORT ? Number(process.env.PORT) : 4000;
app.listen(port, () => {
  console.log(`Nightline API running on http://localhost:${port}`);
});
