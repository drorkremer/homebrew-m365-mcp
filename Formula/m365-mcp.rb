class M365Mcp < Formula
  desc "MCP server for Microsoft 365 via Azure Logic App proxies"
  homepage "https://github.com/drorkremer/homebrew-m365-mcp"
  url "https://github.com/drorkremer/homebrew-m365-mcp/releases/download/v1.0.0/m365_copilot_skill-1.0.0-py3-none-any.whl"
  sha256 "49b4de9892cab741fd3cbd18ec12c60691b4a6fc13c37dd4f38d903074b53938"
  license "MIT"
  version "1.0.0"

  depends_on "python@3.11"
  depends_on "azure-cli"

  def install
    venv = virtualenv_create(libexec, "python3.11")
    system libexec/"bin/pip", "install", cached_download
    bin.install_symlink Dir[libexec/"bin/m365-mcp"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/m365-mcp --version")
  end
end
