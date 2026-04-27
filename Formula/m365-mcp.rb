class M365Mcp < Formula
  desc "MCP server for Microsoft 365 via Azure Logic App proxies"
  homepage "https://github.com/drorkremer/homebrew-m365-mcp"
  url "https://github.com/drorkremer/homebrew-m365-mcp/releases/download/v1.0.0/m365_copilot_skill-1.0.0-py3-none-any.whl", using: :nounzip
  sha256 "c3f001b67eb571fd37668db6bc190349074f84a5f8cc5dc1b16f543abe812a06"
  license "MIT"
  version "1.0.0"

  depends_on "python@3.11"
  depends_on "azure-cli"

  def install
    python = Formula["python@3.11"].opt_bin/"python3.11"
    system python, "-m", "venv", libexec

    # Homebrew renames cached downloads with a hash prefix — restore the original name
    whl = buildpath/"m365_copilot_skill-#{version}-py3-none-any.whl"
    cp cached_download, whl

    system libexec/"bin/pip", "install", "--quiet", whl
    bin.install_symlink Dir[libexec/"bin/m365-mcp"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/m365-mcp --version")
  end
end
