import SwiftUI
import WebKit

struct VLibrasWebView: UIViewRepresentable {
    @Binding var textToTranslate: String

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> WKWebView {
        let webview = WKWebView()
        webview.navigationDelegate = context.coordinator
        webview.isOpaque = false
        webview.backgroundColor = .clear
        webview.scrollView.backgroundColor = .clear
        
        let html = """
        <html>
        <head>
          <meta name='viewport' content='width=device-width, initial-scale=1.0'>
          <script src='https://vlibras.gov.br/app/vlibras-plugin.js'></script>
          <style>
            body { background-color: transparent; margin: 0; padding: 0; }
            #vlibras-invisible-text {
                position: absolute;
                width: 1px;
                height: 1px;
                overflow: hidden;
                clip: rect(0 0 0 0);
                clip-path: inset(100%);
                white-space: nowrap;
                user-select: none;
                pointer-events: none;
            }
          </style>
        </head>
        <body>
          <div vw class="enabled">
            <div vw-access-button class="active"></div>
            <div vw-plugin-wrapper>
              <div class="vw-plugin-top-wrapper"></div>
            </div>
          </div>

          <div id="vlibras-invisible-text"></div>

          <script>
            new window.VLibras.Widget('https://vlibras.gov.br/app');
            function updateInvisibleText(text) {
                const el = document.getElementById('vlibras-invisible-text');
                if (el) {
                    el.innerText = text;
                    const event = new MouseEvent('click', { bubbles: true, cancelable: true });
                    el.dispatchEvent(event);
                }
            }
          </script>
        </body>
        </html>
        """

        
        webview.loadHTMLString(html, baseURL: nil)
        return webview
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard !textToTranslate.isEmpty else { return }
        let escaped = textToTranslate
            .replacingOccurrences(of: "\\", with: "\\\\")
            .replacingOccurrences(of: "'", with: "\\'")
            .replacingOccurrences(of: "\"", with: "\\\"")
            .replacingOccurrences(of: "\n", with: "\\n")
            .replacingOccurrences(of: "\r", with: "")
        let js = "updateInvisibleText('\(escaped)');"
        
        uiView.evaluateJavaScript(js) { (result, error) in
            if let error = error {
                print("JS error: \(error.localizedDescription)")
            }
        }
        
        DispatchQueue.main.async {
            self.textToTranslate = ""  // limpa após enviar
        }
    }

    // MARK: - Coordinator para detectar fim de carregamento e clicar no botão VLibras
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: VLibrasWebView

        init(_ parent: VLibrasWebView) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            let jsClick = "document.querySelector('[vw-access-button]').click();"
            webView.evaluateJavaScript(jsClick) { _, error in
                if let error = error {
                    print("Erro ao clicar no botão VLibras: \(error.localizedDescription)")
                } else {
                    print("Botão VLibras clicado automaticamente")
                }
            }
        }
    }
}
