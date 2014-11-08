//
//  FirstViewController.swift
//  CAOthello
//
//  Created by ALPEN on 2014/11/08.
//  Copyright (c) 2014年 alperithm. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    @IBOutlet weak var turnMessage: UILabel!
    @IBOutlet weak var blackStoneCount: UILabel!
    @IBOutlet weak var whiteStoneCount: UILabel!
    // 定数
    // ボードの中心座標
    var boardCenter:CGPoint = CGPointMake(187.5, 333.5)
    var startPoint: CGPoint = CGPointMake(0, 147)
    
    /*
    盤上管理
    */
    var boardStatus: [[Int]] =
    [[0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0]
    ]
    
    // ターン管理(黒：-1, 白：1)
    var stoneTurn: Int = -1
    
    // 初期化フラグ
    var startFlg: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ゲームの初期化
        initGame()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
        初期設定
    */
    
    // 初期化メソッド
    func initGame() {
        // ボード情報の初期化
        boardStatus = [
            [0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0]
        ]
        
        // ボードの設置
        self.setBoard()
        
        // 初期石配置
        self.setFirstStone()
        startFlg = false
        
        // 先攻後攻設定はここで行う
        stoneTurn = -1
        
        // ターン数の初期化
        blackTurnCount = 1
        whiteTurnCount = 1
        
        // どちらのターンか表示
        turnAlert(stoneTurn)
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
    
    // 石ボタンの設置
    func setFirstStone() {
        setStone(CGPointMake(boardCenter.x - boardWidth*scale/16, boardCenter.y - boardHeight*scale/16), color: -1)
        setStone(CGPointMake(boardCenter.x + boardWidth*scale/16, boardCenter.y - boardHeight*scale/16), color: 1)
        setStone(CGPointMake(boardCenter.x + boardWidth*scale/16, boardCenter.y + boardHeight*scale/16), color: -1)
        setStone(CGPointMake(boardCenter.x - boardWidth*scale/16, boardCenter.y + boardHeight*scale/16), color: 1)
    }
    
    /*
        ターン管理
    */
    
    var blackTurnCount: Int = 1
    var whiteTurnCount: Int = 1
    
    func turnAlert(turn: Int) {
        if turn == 1 {
            turnMessage.text = String(format: "白のターンです：%d手目", whiteTurnCount)
            turnMessage.textColor = UIColor.whiteColor()
        } else {
            turnMessage.text = String(format: "黒のターンです：%d手目", blackTurnCount)
            turnMessage.textColor = UIColor.blackColor()
        }
        blackStoneCount.text = String(format: "黒: %d", countStone(-1))
        blackStoneCount.textColor = UIColor.blackColor()
        whiteStoneCount.text = String(format: "白: %d", countStone(1))
        whiteStoneCount.textColor = UIColor.whiteColor()
    }
    
    func countStone(color: Int) -> Int{
        var count: Int = 0
        for status in boardStatus {
            count += status.filter({$0 == color}).count
        }
        return count
    }
    
    func turnChange() {
        stoneTurn *= -1
        if stoneTurn != -1 {
            blackTurnCount++
        } else {
            whiteTurnCount++
        }
        turnAlert(stoneTurn)
    }
    
    /*
        盤面タップ処理
    */

    // 盤面タップされた箇所の座標を取得
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        for item in touches {
            let touch = item as UITouch
            setStone(touch.locationInView(self.view), color: stoneTurn)
            break
        }
    }
    
    // 石の表記
    var stoneImageView:UIImageView?
    let blackStone:UIImage! = UIImage(named:"disc_black_basic")
    let whiteStone:UIImage! = UIImage(named:"disc_white_basic")
    
    // タッチされた座標からマスを特定し、石をセットする
    func setStone(point: CGPoint, color: Int){
        var relativeX: CGFloat = point.x - startPoint.x
        var relativeY: CGFloat = point.y - startPoint.y
        // 配列番号の設定
        var numberX: Int = Int(relativeX / (boardWidth*scale / 8))
        var numberY: Int = Int(relativeY / (boardHeight*scale / 8))
        // 石を置く座標(左上)
        var stonePosition: CGPoint = CGPointMake(startPoint.x + (boardWidth*scale / 8) * CGFloat(numberX),
            startPoint.y + (boardHeight*scale / 8) * CGFloat(numberY))
        
        if checkPut(numberX, y: numberY) || startFlg {
            // UIImageView インスタンス生成
            // 石の種類を変更
            setStoneImage(stonePosition.x, positionY: stonePosition.y, color: color)
            
            // 盤上情報の更新
            boardStatus[numberX][numberY] = color
            
            // ターンの交代
            turnChange()
        }
    }
    
    func setStoneImage (positionX: CGFloat, positionY: CGFloat, color: Int) {
        if color == 1 {
            stoneImageView = UIImageView(image:whiteStone)
        }else{
            stoneImageView = UIImageView(image:blackStone)
        }
        
        // 石サイズの調整
        var rect:CGRect = CGRectMake(positionX + 5.0, positionY + 5.0, boardWidth*scale / 8 - CGFloat(10.0), boardHeight*scale / 8 - CGFloat(10.0))
        
        // ImageView frame をCGRectMakeで作った矩形に合わせる
        stoneImageView!.frame = rect;
        
        // view に ImageView を追加する
        self.view.addSubview(stoneImageView!)
    }
    
    /*
        オセロルールの設定
    */
    func checkPut(x: Int, y: Int) -> Bool {
        // スタートフラグが立っていたら検知しない
        if startFlg {
            return false
        }
        
        // 既に石がある場所には置けない
        if boardStatus[x][y] != 0 {
            return false
        }
        
        // 裏返せない場所には置けない
        if reverse(x, y: y, doReverse: true) == false {
            showAlert("裏返せない場所には置けません。")
            return false
        }
        
        return true
    }
    
    func reverse(x: Int, y: Int, doReverse: Bool) -> Bool {
        var dir: [[Int]] = [
            [-1,-1], [0,-1], [1,-1],
            [-1, 0],         [1, 0],
            [-1, 1], [0, 1], [1, 1]
        ]
        
        var reversed: Bool = false;
        
        for var i=0; i < 8; i++ {
            //隣のマス
            var x0: Int = x+dir[i][0];
            var y0: Int = y+dir[i][1];
            if(isOut(x0, y: y0) == true){
                continue;
            }
            var nextState: Int = boardStatus[x0][y0];
            if(nextState == stoneTurn){
                continue
            }else if(nextState == 0){
                continue
            }
            
            //隣の隣から端まで走査して、自分の色があればリバース
            var j: Int = 2;
            while(true){
                
                var x1: Int = x + (dir[i][0]*j);
                var y1: Int = y + (dir[i][1]*j);
                if(isOut(x1, y: y1) == true){
                    break
                }
                
                //自分の駒があったら、リバース
                if(boardStatus[x1][y1] == stoneTurn){
                    if doReverse {
                        for var k = 1; k < j; k++ {
                            var x2: Int = x + (dir[i][0]*k)
                            var y2: Int = y + (dir[i][1]*k)
                            boardStatus[x2][y2] *= -1
                            setStoneImage(startPoint.x + (boardWidth*scale / 8) * CGFloat(x2), positionY: startPoint.y + (boardHeight*scale / 8) * CGFloat(y2), color: boardStatus[x2][y2])
                        }
                    }
                    reversed = true
                    break
                }
                
                //空白があったら、終了
                if(boardStatus[x1][y1] == 0){
                    break
                }
                j++
            }
        }
        
        return reversed
    }
    
    func canReverse(x: Int, y: Int) -> Bool{
        return reverse(x, y: y, doReverse: false)
    }
    
    func isOut(x: Int, y: Int) -> Bool{
        if x<0 || y<0 || x>=8 || y>=8 {
            return true
        }
        return false
    }
    
    /*
        アラートウィンドウ表示
    */
    func showAlert (msg: String) {
        var alert = UIAlertView()
        alert.title = "警告！"
        alert.message = msg
        alert.addButtonWithTitle("OK")
        alert.show()
    }
}

