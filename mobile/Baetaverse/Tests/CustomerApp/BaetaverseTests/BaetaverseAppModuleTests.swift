//
//  BaetaverseAppModuleTests.swift
//  BaetaverseTests
//
//  Created by JeongTaek Han on 2022/03/31.
//

import XCTest

class BaetaverseAppModuleTests: XCTestCase {
    
    private var sutBaetaverse: AppService!

    override func setUpWithError() throws {
        self.sutBaetaverse = BaetaverseAppService.configure()
    }

    override func tearDownWithError() throws {
        self.sutBaetaverse = nil
    }

    func test_알맞은_계정이_입력되면_정상적으로_로그인되어야한다() async throws {
        // given
        let email = "test1@test1.com"
        let password = "12341234"
        
        // when
        try await sutBaetaverse.login(
            email: email,
            password: password
        )
        
        // then
        XCTAssertTrue(sutBaetaverse.isLogin)
    }
    
    func test_비밀번호가_잘못된_계정이_입력되면_오류를_반환해야한다() async throws {
        // given
        let email = "test1@test1.com"
        let password = "1234"
        
        // when then
        do {
            try await sutBaetaverse.login(
                email: email,
                password: password
            )
            XCTFail("로그인에 실패해야 하는데 성공하는 오류 발생")
        } catch {
            XCTAssertTrue(true)
        }
    }
    
    func test_없는_사용자_계정으로_로그인하면_오류를_반환해야한다() async throws {
        // given
        let email = "unknown@unknown.com"
        let password = "1234"
        
        // when then
        do {
            try await sutBaetaverse.login(
                email: email,
                password: password
            )
            XCTFail("로그인에 실패해야 하는데 성공하는 오류 발생")
        } catch {
            XCTAssertTrue(true)
        }
    }
    
    func test_회원가입_정상적으로_동작해야한다() async throws {
        // given
        let email = "test2@test2.com"
        let password = "12341234"
        let name = "testUserName"
        let phoneNumber = "010-1234-5678"
        
        // when then
        do {
            try await sutBaetaverse.signUp(
                email: email,
                password: password,
                name: name,
                phoneNumber: phoneNumber
            )
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func test_이미_등록된_사용자가_회원가입하면_오류를_반환해야한다() async throws {
        // given
        let email = "test1@test1.com"
        let password = "12341234"
        let name = "testUserName"
        let phoneNumber = "010-1234-5678"
        
        // when then
        do {
            try await sutBaetaverse.signUp(
                email: email,
                password: password,
                name: name,
                phoneNumber: phoneNumber
            )
            XCTFail("사용자가 중복 가입되었습니다")
        } catch {
            XCTAssertTrue(true)
        }
    }
    
    func test_010121_코드가_입력되면_살아있는_말이_반환되어야_한다() async throws {
        // given
        let email = "test1@test1.com"
        let password = "12341234"
        let code = "010121"
        
        // when
        try await sutBaetaverse.login(
            email: email,
            password: password
        )
        
        let result = try await sutBaetaverse.queryHSCode(code: code)
        
        // then
        XCTAssertEqual(result, ["010121 : 말(번식용,산동물)"])
    }
    
    func test_로그인된_사용자의_견적요청서_명단이_조회되어야한다() async throws {
        // given
        let email = "test1@test1.com"
        let password = "12341234"
        
        try await sutBaetaverse.login(
            email: email,
            password: password
        )
        
        // when
        let result = try? await sutBaetaverse.queryEstimateRequests()
        if let result = result {
            print(result)
        }
        
        // then
        XCTAssertNotNil(result)
    }
    
    func test_새로운_견적_등록하기가_정상적으로_동작해야한다() async throws {
        // given
        let email = "test1@test1.com"
        let password = "12341234"
        
        let estimateRequest = EstimateRequest(
            id: nil,
            tradeType: "수입",
            tradeDetail: "Port to Port",
            forwardingDate: Date(),
            departureCountry: "USA",
            departureDetail: "NewYork",
            destinationCountry: "South Korea",
            destinationDetail: "Seoul",
            incoterms: "DEF",
            closingDate: Date(),
            createdAt: nil
        )
        
        let products = [
            Product(
                id: nil,
                name: "Apple MacBook Pro",
                price: 2490000,
                weight: 10,
                standardUnit: "Kg",
                hsCode: "123456",
                createdAt: nil
            )
        ]
        
        try await sutBaetaverse.login(
            email: email,
            password: password
        )
        
        // when
        try await sutBaetaverse.registerEvaluate(
            estimateRequest: estimateRequest,
            products: products
        )
        
        // then
        XCTAssert(true)
    }
    
    func test_로그인한_사용자의_2번_견적서가_정상적으로_조회되어야_한다() async throws {
        // given
        let email = "test1@test1.com"
        let password = "12341234"
        
        try await sutBaetaverse.login(
            email: email,
            password: password
        )
        
        // when then
        do {
            let result = try await sutBaetaverse.queryEstimateRequestDetail(id: "2")
            XCTAssertNotNil(result)
        } catch {
            XCTFail("\(error)")
        }
    }

}