//
//  ViewController.swift
//  TicTacToeGame
//
//  Created by Kishan Barmawala on 25/03/23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet var buttons: [UIButton]!
    
    var board = [[" "," "," "],[" "," "," "],[" "," "," "]]
    var currentPlayer = String()
    enum Players: String {
        case X = "X"
        case O = "O"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setFirstPlayer(name: .O)
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        
        sender.setTitle(currentPlayer, for: .normal)
        
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
            if checkWin() {
                showWinnerAlert(isDraw: false)
                return
            }
            if checkDraw() {
                showWinnerAlert(isDraw: true)
                return
            }
            switchPlayer()
        } else {
            print("Invalid move, try again")
        }
        
    }
    
    @IBAction func resetTapped(_ sender: UIButton) {
        currentPlayer = "X"
        board = [[" "," "," "],[" "," "," "],[" "," "," "]]
        buttons.forEach({ $0.setTitle("", for: .normal) })
        buttons.forEach({ $0.isUserInteractionEnabled = true })
    }
    
    func setFirstPlayer(name: Players) {
        currentPlayer = name.rawValue
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
    
    func checkWin() -> Bool {
        for i in 0...2 {
            if board[i][0] == currentPlayer && board[i][1] == currentPlayer && board[i][2] == currentPlayer {
                return true
            }
        }
        for i in 0...2 {
            if board[0][i] == currentPlayer && board[1][i] == currentPlayer && board[2][i] == currentPlayer {
                return true
            }
        }
        if board[0][0] == currentPlayer && board[1][1] == currentPlayer && board[2][2] == currentPlayer {
            return true
        }
        if board[0][2] == currentPlayer && board[1][1] == currentPlayer && board[2][0] == currentPlayer {
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
    
    func showWinnerAlert(isDraw: Bool) {
        let title = isDraw ? "Oops!" : "Hurray! We have a winner"
        let message = isDraw ? "Match draw!": "Player \(currentPlayer) wins!"
        let alert = UIAlertController(title: title, message: "\n" + message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
        buttons.forEach({ $0.isUserInteractionEnabled = false })
        lblStatus.text = message
    }
    
}
