import { PrismaClient, CrowdLevel } from "@prisma/client";

const prisma = new PrismaClient();

async function main() {
  await prisma.checkIn.deleteMany();
  await prisma.bar.deleteMany();

  const bars = await prisma.bar.createMany({
    data: [
      {
        name: "Balboa Cafe",
        address: "3199 Fillmore St",
        city: "San Francisco, CA",
        latitude: 37.7983,
        longitude: -122.4369,
        amenities: ["Food", "Cocktails", "Outdoor Seating"],
        vibe: "Mixed",
        busyPercent: 88
      },
      {
        name: "Palm House",
        address: "2032 Union St",
        city: "San Francisco, CA",
        latitude: 37.7976,
        longitude: -122.4343,
        amenities: ["Tropical", "Cocktails", "Outdoor Seating"],
        vibe: "Younger",
        busyPercent: 79
      },
      {
        name: "The Interval",
        address: "2 Marina Blvd",
        city: "San Francisco, CA",
        latitude: 37.8067,
        longitude: -122.4334,
        amenities: ["Coffee", "Books", "Quiet"],
        vibe: "Chill",
        busyPercent: 52
      }
    ]
  });

  const barList = await prisma.bar.findMany();

  if (barList.length > 0) {
    await prisma.checkIn.createMany({
      data: [
        {
          barId: barList[0].id,
          crowdLevel: CrowdLevel.PACKED,
          observations: ["Line outside", "Great vibe"]
        },
        {
          barId: barList[1].id,
          crowdLevel: CrowdLevel.BUSY,
          observations: ["Fast bar service"]
        },
        {
          barId: barList[2].id,
          crowdLevel: CrowdLevel.MEDIUM,
          observations: ["No line"]
        }
      ]
    });
  }

  console.log(`Seeded ${bars.count} bars.`);
}

main()
  .catch((error) => {
    console.error(error);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
