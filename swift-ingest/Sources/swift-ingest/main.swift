import Foundation

struct CLIOptions {
    let input: URL
    let output: URL
    let strict: Bool
}

func parseArgs() -> CLIOptions? {
    var input: String? = nil
    var output: String? = nil
    var strict = false
    var it = CommandLine.arguments.makeIterator()
    _ = it.next() // program
    while let arg = it.next() {
        switch arg {
        case "--input":
            input = it.next()
        case "--output":
            output = it.next()
        case "--strict":
            strict = true
        default:
            break
        }
    }
    guard let inS = input, let outS = output else { return nil }
    return CLIOptions(input: URL(fileURLWithPath: inS), output: URL(fileURLWithPath: outS), strict: strict)
}

guard let opts = parseArgs() else {
    print("Usage: swift-ingest --input <input-dir> --output <output-dir> [--strict]")
    exit(1)
}

let fm = FileManager.default
if !fm.fileExists(atPath: opts.output.path) {
    try fm.createDirectory(at: opts.output, withIntermediateDirectories: true)
}

let decoder = JSONDecoder()
let encoder = JSONEncoder()
encoder.outputFormatting = [.prettyPrinted, .sortedKeys]

guard let files = try? fm.contentsOfDirectory(at: opts.input, includingPropertiesForKeys: nil) else {
    print("Failed to list input dir: \(opts.input.path)")
    exit(1)
}

var accepted = 0
var rejected = 0

for file in files where file.pathExtension.lowercased() == "json" {
    do {
        let data = try Data(contentsOf: file)
        let match = try decoder.decode(Match.self, from: data)
        try match.validate()
        let cleaned = try encoder.encode(match)
        let outURL = opts.output.appendingPathComponent(file.lastPathComponent)
        try cleaned.write(to: outURL)
        accepted += 1
    } catch {
        rejected += 1
        print("Rejected \(file.lastPathComponent): \(error)")
        if opts.strict {
            exit(2)
        }
    }
}

print("Done. Accepted: \(accepted). Rejected: \(rejected)")
