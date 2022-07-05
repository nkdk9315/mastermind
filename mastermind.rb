# frozen_string_literal: true

# ゲームクラス
class Game
  def initialize(user_name)
    @user_name = user_name
    @answer = []
    @player_turn_count = 0
    @computer_turn_count = 0
    # 1~6までのランダムな数字を４つ並べた配列を作る
    4.times do
      answer.push(rand(1...6).to_s)
    end
  end

  # プレイヤーに数字を入力させる関数
  def input_players_number
    number = nil
    puts "#{user_name}'s turn! Guess 4 digits number. Each digit is 1 ~ 6."
    loop do
      print 'number: '
      begin
        number = gets.chomp
      rescue Interrupt
        puts "\n"
        exit
      end
      break if number.to_i.to_s == number && number.length == 4

      puts 'Invalid input. Try again'
    end
    number
  end

  # 予想された数字のヒット数を計算する関数
  def calc_hit_count(number_array, answer_copy)
    hit = 0
    number_array.each_with_index do |num, index|
      next if num != answer_copy[index]

      answer_copy[index] = nil
      number_array[index] = nil
      hit += 1
    end
    hit
  end

  # 予想された数字のブロー数を計算する関数
  def calc_brow_count(number_array, answer_copy)
    # ブロー数を求める
    brow = 0
    number_array.each do |num|
      if !num.nil? && answer_copy.include?(num)
        brow += 1
        answer_copy.delete_at(answer_copy.index(num))
      end
    end
    brow
  end

  # プレイヤーが回答者の場合実行される関数
  def player_guessing
    loop do
      # プレイヤーから数字を受け取る
      number = input_players_number
      # プレイヤーのターン数を更新
      @player_turn_count += 1
      # 答えがあっていたら終了
      if number == answer.join
        puts "Correct! The number of turns taken is #{player_turn_count}"
        break
      end
      # 予想された数字が入った配列
      number_array = number.split('')
      # answerが変更されないようコピー
      answer_copy = answer.clone
      # numberのヒットとブローの数を求め,出力
      hit = calc_hit_count(number_array, answer_copy)
      brow = calc_brow_count(number_array, answer_copy)
      puts "#{hit} hits, #{brow} brow!"
      # １２ターンが終わったら強制終了
      next if player_turn_count != 12

      puts '12 turns have passed. Your turn is finished.'
      puts "Answer: #{answer.join}"
      break
    end
  end

  # コンピュータが回答者の場合実行される関数
  def computer_guessing
  end

  # 結果を表示する関数
  def display_result
    result = "Computer: #{computer_turn_count} turns, #{user_name}: #{player_turn_count} turns"

    if player_turn_count < computer_turn_count
      puts "#{result}\n#{user_name} wins!"
    elsif player_turn_count > computer_turn_count
      puts "#{result}\nComputer wins!"
    else
      puts result
      puts "#{result}\nDraw!"
    end
  end

  # ゲームをプレイする関数
  def play
    # プレイヤーが回答者の場合
    player_guessing
    # コンピュータが回答者の場合
    computer_guessing
    # 結果を表示
    display_result
  end

  private

  attr_accessor :user_name, :answer, :player_turn_count, :computer_turn_count
end

game = Game.new('肉おじゃ')
game.play
