import Foundation

let fileAccessKey = "ol3TjWA0Gd5x8BtOkRU3mrbW49yTSvUR35O8qjIBcZs"
let fileSecretKey = "w_6bvmnu1jii0tq5rdL2ENsPoaIO6qlSe0U9SlkKC-w"
let fileRedirectURI = "urn:ietf:wg:oauth:2.0:oob"
let fileAccessScope = "public+read_user+write_likes"
let fileDefaultBaseUrl = URL(string: "https://api.unsplash.com")!
let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
let photosUrl = "https://api.unsplash.com/photos"

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseUrl: URL
    let authURLString: String
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(accessKey: fileAccessKey,
                                 secretKey: fileSecretKey,
                                 redirectURI: fileRedirectURI,
                                 accessScope: fileAccessScope,
                                 defaultBaseUrl: fileDefaultBaseUrl,
                                 authURLString: unsplashAuthorizeURLString)
    }
}


