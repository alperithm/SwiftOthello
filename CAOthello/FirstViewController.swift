//
//  FirstViewController.swift
//  CAOthello
//
//  Created by ALPEN on 2014/11/08.
//  Copyright (c) 2014年 alperithm. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    // 定数
    // ボードの中心座標
    var boardCenter:CGPoint = CGPointMake(187.5, 333.5)
    
    // ターン管理(黒：0, 白：1)
    var stoneTurn: Boolean = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ボードの設置
        self.setBoard()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 石ボタンの設置
    func setFirstStone() {
        
    }
    
    // ボード表記
    var boardImageView:UIImageView?
    var scale:CGFloat = 1.0
    var boardWidth:CGFloat = 0
    var boardHeight:CGFloat = 0
    var screenWidth:CGFloat = 0
    var screenHeight:CGFloat = 0
    
    func setBoard() {
        // Screen Size の取得
        screenWidth = self.view.bounds.width
        screenHeight = self.view.bounds.height
        
        // UIImage インスタンスの生成
        let image:UIImage! = UIImage(named:"board")
        
        // 画像の幅・高さの取得
        boardWidth = image!.size.width
        boardHeight = image!.size.height
        
        // UIImageView インスタンス生成
        boardImageView = UIImageView(image:image)
        
        // 画像サイズをスクリーン幅に合わせる
        scale = screenWidth / boardWidth
        var rect:CGRect = CGRectMake(0, 0, boardWidth*scale, boardHeight*scale)
        
        // ImageView frame をCGRectMakeで作った矩形に合わせる
        boardImageView!.frame = rect;
        
        // 画像の中心を187.5, 333.5 の位置に設定、iPhone6のケース
        boardImageView!.center = boardCenter
        
        // タッチイベントを有効にする
        boardImageView!.userInteractionEnabled = true
        
        // view に ImageView を追加する
        self.view.addSubview(boardImageView!)
    }
    
    /*
        盤面タップ処理
    */

    // 盤面タップされた箇所の座標を取得
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        for item in touches {
            let touch = item as UITouch
            setStone(touch.locationInView(self.view))
            break
        }
    }
    
    // 石の表記
    var stoneImageView:UIImageView?
    let blackStone:UIImage! = UIImage(named:"disc_black_basic")
    let whiteStone:UIImage! = UIImage(named:"disc_white_basic")
    
    // タッチされた座標からマスを特定し、石をセットする
    func setStone(point: CGPoint){
        var startPoint: CGPoint = CGPointMake(boardCenter.x - boardWidth*scale/2, boardCenter.y - boardHeight*scale/2)
        var relativeX: CGFloat = point.x - startPoint.x
        var relativeY: CGFloat = point.y - startPoint.y
        // 配列番号の設定
        var numberX: Int = Int(relativeX / (boardWidth*scale / 8))
        var numberY: Int = Int(relativeY / (boardHeight*scale / 8))
        // 石を置く座標(左上)
        var stonePosition: CGPoint = CGPointMake(startPoint.x + (boardWidth*scale / 8) * CGFloat(numberX),
            startPoint.y + (boardHeight*scale / 8) * CGFloat(numberY))
        
        // UIImageView インスタンス生成
        // ターン毎に石の種類を変更
        if stoneTurn == 1 {
            stoneImageView = UIImageView(image:whiteStone)
            stoneTurn = 0
        }else{
            stoneImageView = UIImageView(image:blackStone)
            stoneTurn = 1
        }
        
        // 石サイズの調整
        var rect:CGRect = CGRectMake(stonePosition.x + 5.0, stonePosition.y + 5.0, boardWidth*scale / 8 - CGFloat(10.0), boardHeight*scale / 8 - CGFloat(10.0))
        
        // ImageView frame をCGRectMakeで作った矩形に合わせる
        stoneImageView!.frame = rect;
        
        // view に ImageView を追加する
        self.view.addSubview(stoneImageView!)

    }
}

