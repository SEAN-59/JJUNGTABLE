#  계정 관련

## KAKAO
Link:https://developers.kakao.com/console/app/987284
Account: sean.kk@kakao.com

## NAVER
Link: https://console.ncloud.com/naver-service/application
Account: sean_kk@naver.com

# Protocol 관련
## 공통단으로 사용하기 위한 protocol 운영시에 Any로 값을 보내는데 해당 값을 구성하는 방식은 보내는 쪽의 (Object's Identifier: Data) 식으로 보내서 구분이 가능하게 하는게 좋을것 같다. 


# 주석
## [THINKING] 의 경우 조건 생각해볼것
## Remove, test 처리 된 코드는 다 삭제 할 예정 



    func readDataBase(key: String, completion: @escaping (DataBase) -> Void) {
        // key 가 빈값으로 올 경우 바로 Type으로 만들지만 그게 아니고 key에 다른 주소가 같이 들어온다면 그 부분을 포함해서 주소 구성
        self.readDataBase(key: "go") { result in
            if let check2 = result as? DB_FAILURE {
                printLog(check2)
            }
            
        }
        self.readDataBase(key: "") { result in
            printLog(result)
        }

        
        if key == "" {
            completion(DB_FAILURE(key: "out", type: .friends, errorType: .db_CreateERROR))
        } else {
            completion(DB_SUCCESS(key: "go", type: .getFriend))
        }
        
    }
    
        DatabaseManager().readDataBase(.user, key: loginId) { dataBase in
            if let db = dataBase as? DB_SUCCESS {
                printLog(db.key)
                printLog(db.value)
            }
            else if let db = dataBase as? DB_FAILURE {
                printLog(db.key)
            }
        }
