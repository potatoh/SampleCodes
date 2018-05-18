import Alamofire
import RxAlamofire
import RxSwift
import SwiftyJSON

struct Api {
	 
	    public static func getReceivedBottles() -> Observable<(HTTPURLResponse, NSArray)> {
        print("inside api call")
        return Observable.create({ (observer) -> Disposable in
            Alamofire.request(Router.getReceivedBottles)
                .rx
                .responseJSON()
                .subscribe(onNext: { (response, json) in
                    if let data = json as? NSArray {
                        observer.on(.next((response, data)))
                        observer.on(.completed)
                    }
                }, onError: { error in
                    observer.on(.error(error))
                }, onCompleted: nil, onDisposed: nil)
        })
        
        
        
    }
}