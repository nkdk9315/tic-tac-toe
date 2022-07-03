# frozen_string_literal: true

# playerクラス
class Player
  # 名前と順番のインスタンス変数
  def initialize(name)
    @name = name
  end

  attr_accessor :name, :number, :symbol
end

# ゲームオブジェクト
class Game
  def initialize(player1, player2)
    @player1 = player1
    @player2 = player2

    # 盤面の丸とバツの位置を表す２重配列
    @game_array = Array.new(3) { Array.new(3, ' ') }
    # 勝者
    @winner = nil
    # ゲームカウント変数
    @game_count = 0
    # playerの順番と○か×かを決める
    player1.number = 1
    player1.symbol = '○'

    player2.number = 2
    player2.symbol = '×'
  end

  # 与えられた配列がすべて記号と一致するか確認する関数
  def check_same(array, symbol)
    array.all? { |item| item == symbol }
  end

  # 勝敗を確認する関数
  def check_win(player)
    3.times do |i|
      # 横がすべて同じ記号か調べる
      if check_same(game_array[i], player.symbol)
        @winner = player
        break
      end
      # 縦がすべて同じ記号か調べる
      checked_array = [game_array[0][i], game_array[1][i], game_array[2][i]]
      if check_same(checked_array, player.symbol)
        @winner = player
        break
      end
    end
    # 斜めがすべて同じ記号か調べる
    unless winner
      checked_array = [game_array[0][0], game_array[1][1], game_array[2][2]]

      if check_same(checked_array, player.symbol)
        @winner = player
        return
      end

      checked_array = [game_array[0][2], game_array[1][1], game_array[2][0]]

      @winner = player if check_same(checked_array, player.symbol)
    end
  end

  # 盤面を表示する関数
  def display
    print "\n"
    3.times do |i|
      3.times do |j|
        print game_array[i][j]
        print '|' unless j == 2
      end
      print "\n"
      next if i == 2

      5.times { print '-' }
      print "\n"
    end
    print "\n"
  end

  # プレイヤーからマス目の数字を受け取る関数
  def take_user_input(printed_string, player)
    loop do
      print printed_string
      begin
        num = gets.to_f
      rescue Interrupt
        print "\n"
        exit
      end
      return num.to_i if (num >= 1) && (num <= 3) && (num == num.to_i)

      # 1~3の整数以外のときは質問をし直す
      display
      puts 'Enter an integer from 1 to 3. Try again!'
      puts "#{player.name} (#{player.symbol})"
      next
    end
  end

  # プレイヤーターンの処理をする関数
  def make_move(player)
    # ゲームのターン数を更新
    @game_count += 1
    # 盤面を表示
    display
    # マス目の変数を初期化
    row = nil
    column = nil
    # プレイヤーからのマス目の入力を受け取り、挿入
    loop do
      puts "#{player.name} (#{player.symbol})"
      row = take_user_input('Row: ', player)
      column = take_user_input('Column: ', player)
      # 既に盤面に記号がある場合はまた質問を繰り返す
      if game_array[row - 1][column - 1] != ' '
        display
        puts 'That square is already filled. Try again!'
        next
      end
      break
    end
    # 盤面を更新
    game_array[row - 1][column - 1] = player.symbol
    # プレイヤーが勝ったかどうか確かめる
    check_win(player)
  end

  # ゲームをプレイする関数
  def play
    # ゲームループ
    loop do
      # ゲームカウントによってプレイヤーのターンを決定
      if game_count.even?
        make_move(player1)
      else
        make_move(player2)
      end
      # その時点で勝ちが決まっていれば終了
      if winner
        display
        puts "#{winner.name} wins!!!"
        break
      end
      # ９戦目で勝ちが決まっていなければ引き分け
      if game_count == 9
        display
        puts 'Draw!'
        break
      end
    end
  end

  private

  attr_accessor :player1, :player2, :winner, :game_count, :game_array
end

player1 = Player.new('Player 1')
player2 = Player.new('Player 2')
p player1

game = Game.new(player1, player2)
game.play
