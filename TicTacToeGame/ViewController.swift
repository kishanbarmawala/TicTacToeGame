//
//  ViewController.swift
//  TicTacToeGame
//
//  Created by Kishan Barmawala on 25/03/23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var gameView: UIView!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet var buttons: [UIButton]!
    
    var board = [[" "," "," "],[" "," "," "],[" "," "," "]]
    var currentPlayer = String()
    let startPlayer = "X"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setFirstPlayer()
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        
        var col: Int = 0
        var row: Int = 0
        let clickIndex = sender.tag
        
        if (0...2).contains(clickIndex) {
            col = 0
            row = clickIndex
        } else if (3...5).contains(clickIndex) {
            col = 1
            row = clickIndex - 3
        } else if (6...8).contains(clickIndex) {
            col = 2
            row = clickIndex - 6
        }
        
        if makeMove(row: row, col: col) {
            sender.setTitle(currentPlayer, for: .normal)
            if checkWin(viewIndex: clickIndex) {
                showWinnerAlert(isDraw: false)
                return
            }
            if checkDraw() {
                showWinnerAlert(isDraw: true)
                return
            }
            switchPlayer()
        }
        
    }
    
    @IBAction func resetTapped(_ sender: UIButton) {
        setFirstPlayer()
        gameView.layer.sublayers?.removeAll(where: { $0.name == "winningLine" })
        board = [[" "," "," "],[" "," "," "],[" "," "," "]]
        buttons.forEach({ $0.setTitle("", for: .normal) })
        buttons.forEach({ $0.isUserInteractionEnabled = true })
    }
    
    func setFirstPlayer() {
        currentPlayer = startPlayer
        lblStatus.text = "Player \(currentPlayer) turn"
    }
    
    func makeMove(row: Int, col: Int) -> Bool {
        if board[col][row] == " " {
            board[col][row] = currentPlayer
            return true
        } else {
            return false
        }
    }
    
    func checkWin(viewIndex: Int) -> Bool {
        for i in 0...2 { // Horizontal
            if board[i][0] == currentPlayer && board[i][1] == currentPlayer && board[i][2] == currentPlayer {
                let startPointView = buttons[i * 3]
                let endPointView = buttons[(i * 3) + 2]
                drawLineFrom(startPointView, to: endPointView)
                return true
            }
        }
        for i in 0...2 { // Vertical
            if board[0][i] == currentPlayer && board[1][i] == currentPlayer && board[2][i] == currentPlayer {
                let startPointView = buttons[i]
                let endPointView = buttons[i + 6]
                drawLineFrom(startPointView, to: endPointView)
                return true
            }
        }
        if board[0][0] == currentPlayer && board[1][1] == currentPlayer && board[2][2] == currentPlayer { // Backslash
            drawLineFrom(buttons[0], to: buttons[8])
            return true
        }
        if board[0][2] == currentPlayer && board[1][1] == currentPlayer && board[2][0] == currentPlayer { // forwardslash
            drawLineFrom(buttons[2], to: buttons[6])
            return true
        }
        return false
    }
    
    func checkDraw() -> Bool {
        let res = board.flatMap { $0 }
        if !res.contains(" ") {
            return true
        }
        return false
    }
    
    func switchPlayer() {
        if currentPlayer == "X" {
            currentPlayer = "O"
        } else {
            currentPlayer = "X"
        }
    }
    
    func drawLineFrom(_ startView: UIView, to endView: UIView) {

        let fFrame = gameView.getConvertedFrame(fromSubview: startView)
        let eFrame = gameView.getConvertedFrame(fromSubview: endView)
        let fPoint = CGPoint(x: fFrame!.midX, y: fFrame!.midY)
        let ePoint = CGPoint(x: eFrame!.midX, y: eFrame!.midY)

        let path = UIBezierPath()
        path.move(to: fPoint)
        path.addLine(to: ePoint)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.orange.cgColor
        shapeLayer.lineWidth = 3.0
        shapeLayer.name = "winningLine"
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.duration = 0.3
        shapeLayer.add(animation, forKey: "strokeAnimation")
        
        gameView.layer.addSublayer(shapeLayer)
        
    }
    
    func showWinnerAlert(isDraw: Bool) {
        let title = isDraw ? "Oops!" : "Hurray! We have a winner"
        let message = isDraw ? "Match draw!": "Player \(currentPlayer) wins!"
        let alert = UIAlertController(title: title, message: "\n" + message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//        present(alert, animated: true)
        buttons.forEach({ $0.isUserInteractionEnabled = false })
        lblStatus.text = message
        currentPlayer = startPlayer
    }
    
}

