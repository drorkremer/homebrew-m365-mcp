class M365Mcp < Formula
  desc "MCP server for Microsoft 365 via Azure Logic App proxies"
  homepage "https://github.com/drorkremer/homebrew-m365-mcp"
  version "1.0.0"
  license "MIT"

  depends_on "python@3.11"
  depends_on "azure-cli"

  # ADO Artifacts feed credentials (read-only)
  ADO_INDEX = "https://read:7rdCsetPal0TYstp5jhAyA7ZFw4koB6IcbRDHxa9XSfi4xjjPRqVJQQJ99CDACAAAAAAAAAAAAASAZDOmRZo@pkgs.dev.azure.com/ghostwheel/_packaging/m365-mcp/pypi/simple/"

  def install
    venv = virtualenv_create(libexec, "python3.11")
    system libexec/"bin/pip", "install",
           "--index-url", ADO_INDEX,
           "--extra-index-url", "https://pypi.org/simple/",
           "m365-copilot-skill==#{version}"
    bin.install_symlink Dir[libexec/"bin/m365-mcp"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/m365-mcp --version")
  end
end
