import Foundation

struct APIConfig {
    var baseURL: URL

    static let local = APIConfig(baseURL: URL(string: "http://localhost:4000")!)
}

@MainActor
final class APIClient: ObservableObject {
    private let config: APIConfig
    private let session: URLSession

    init(config: APIConfig = .local, session: URLSession = .shared) {
        self.config = config
        self.session = session
    }

    func fetchBars() async throws -> [Bar] {
        let url = config.baseURL.appendingPathComponent("bars")
        return try await load(url: url)
    }

    func fetchBarDetail(id: String) async throws -> Bar {
        let url = config.baseURL.appendingPathComponent("bars/")
            .appendingPathComponent(id)
        return try await load(url: url)
    }

    func fetchLiveFeed() async throws -> [CheckIn] {
        let url = config.baseURL.appendingPathComponent("live")
        return try await load(url: url)
    }

    func createCheckIn(request: CheckInRequest) async throws -> CheckIn {
        let url = config.baseURL.appendingPathComponent("checkins")
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try JSONEncoder.api.encode(request)
        return try await load(request: urlRequest)
    }

    func fetchTrend(barId: String, hours: Int) async throws -> TrendResponse {
        var components = URLComponents(url: config.baseURL.appendingPathComponent("bars/")
            .appendingPathComponent(barId)
            .appendingPathComponent("trend"), resolvingAgainstBaseURL: false)
        components?.queryItems = [URLQueryItem(name: "hours", value: "\(hours)")]

        guard let url = components?.url else {
            throw URLError(.badURL)
        }

        return try await load(url: url)
    }

    private func load<T: Decodable>(url: URL) async throws -> T {
        let (data, response) = try await session.data(from: url)
        try validate(response: response)
        return try JSONDecoder.api.decode(T.self, from: data)
    }

    private func load<T: Decodable>(request: URLRequest) async throws -> T {
        let (data, response) = try await session.data(for: request)
        try validate(response: response)
        return try JSONDecoder.api.decode(T.self, from: data)
    }

    private func validate(response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else { return }
        guard (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
    }
}

extension JSONDecoder {
    static let api: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
}

extension JSONEncoder {
    static let api: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }()
}
