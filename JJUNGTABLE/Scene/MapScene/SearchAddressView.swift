//
//  SearchAddressView.swift
//  JJUNGTABLE
//
//  Created by Sean Kim on 1/10/24.
//

import UIKit
import SnapKit
import WebKit

class SearchAddressView: BaseView {
    static let identifier = "SearchAddressView"
    weak var delegate: ViewDelegate?
    
    private var webView: WKWebView!
    
    @IBOutlet weak var contentView: UIView!
    
    override func viewLoad() {
        // JS 가 보내는 메세지를 읽기 위한 인스턴스
        let contentController = WKUserContentController()
        let configuration = WKWebViewConfiguration()
        //캐시 메모리 전체 삭제
        URLCache.shared.removeAllCachedResponses()
        URLCache.shared.diskCapacity = 0
        URLCache.shared.memoryCapacity = 0
        
        contentController.add(self, name: "callBackHandler")
        
        configuration.userContentController = contentController
        
        self.webView = WKWebView(frame: .zero, configuration: configuration)

        self.webView.navigationDelegate = self
        self.webView.uiDelegate = self
        
        self.webView.scrollView.alwaysBounceVertical = false
        self.webView.scrollView.bounces = false
        self.webView.clipsToBounds = true
        
        let preferences = WKPreferences()
        let defaultPreferences = WKWebpagePreferences()
                
        if #available(iOS 14.0, *) {
            defaultPreferences.allowsContentJavaScript = true
        } else {
            preferences.javaScriptEnabled = true
        }
        
        self.webView.configuration.preferences = preferences
        self.webView.configuration.defaultWebpagePreferences = defaultPreferences
        
//        self.webView.configuration.defaultWebpagePreferences.allowsContentJavaScript = true
//        self.webView.configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
        
        
        if let url = URL(string: KEY.githubPagesLink) {
            let request = URLRequest(url: url)
            self.webView.load(request)
        }
        
        self.contentView.addSubview(self.webView)
        self.webView.snp.updateConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.showIndicator()
    }
    
    func drawMap(corner: CGFloat = 0,
                 mask: CACornerMask = CACornerMask(arrayLiteral:.layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner),
                 color: UIColor? = nil, width: CGFloat = 0) {
        self.webView.layer.maskedCorners = mask
        self.webView.layer.cornerRadius = corner
        self.webView.layer.borderColor = color?.cgColor
        self.webView.layer.borderWidth = width
    }
}

extension SearchAddressView: WKScriptMessageHandler, WKUIDelegate {
    // 이 함수가 호출되는 타이밍은 유저가 주소를 검색하고 어떤 값을 최종 선택했을때 호출 될 것 임
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        printLog("message: \(message)")
        if message.name == "callBackHandler", let data = message.body as? [String: Any] {
            let address = data["roadAddress"] as? String ?? ""
            
            self.delegate?.sendViewData(identifier: SearchAddressView.identifier, data: address)
            printLog("address: \(address)")
        }
    }
}

extension SearchAddressView: WKNavigationDelegate {
    //  WebView 의 로드가 시작 될 때
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.showIndicator()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.stopIndicator()
    }
}
