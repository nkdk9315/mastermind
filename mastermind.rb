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
      answer.push(rand(1..6).to_s)
    end
  end

  # 入力されたものが適切な数字か判断する関数
  def validate_input(input)
    if input.length == 4 && input.to_i.to_s == input && input.split('').map(&:to_i).all? { |num| num >= 1 && num <= 6 }
      true
    else
      false
    end
  end

  # プレイヤーに数字を入力させる関数
  def input_players_number
    number = nil
    loop do
      print 'number: '
      begin
        number = gets.chomp
      rescue Interrupt
        puts "\n"
        exit
      end
      break if validate_input(number)

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
      puts "#{user_name}'s turn! Guess 4 digits number. Each digit is 1 ~ 6."
      # プレイヤーから数字を受け取る
      number = input_players_number
      # プレイヤーのターン数を更新
      @player_turn_count += 1
      # 答えがあっていたら終了
      if number == answer.join
        puts "Correct! The number of turns #{user_name} took was #{player_turn_count}!"
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

  # 配列から一致する要素を一つずつ消す関数
  def slice_array(array, items)
    array_copy = array.clone
    items.each do |item|
      array_copy.delete_at(array_copy.index(item))
    end
    array_copy
  end

  # 与えられた数字の組み合わせをすべて含んだ配列を返す関数
  def combination_of_item(array)
    new_array = []
    array.each do |i|
      slice_array(array, [i]).each do |j|
        slice_array(array, [i, j]).each do |k|
          slice_array(array, [i, j, k]).each do |l|
            new_array.push(i + j + k + l)
          end
        end
      end
    end
    new_array.uniq
  end

  # コンピュータが正解を予測した数値を生成する関数
  def generate_numbers(computer_turn_count, current_number, hit, brow)
    # 正解に含まれている数字の数
    correct_number_count = hit + brow
    return '1111' if computer_turn_count == 1

    next_number = (current_number[-1].to_i + 1).to_s
    current_number[0, correct_number_count] + next_number * (4 - correct_number_count)
  end

  # コンピュータが回答者の場合実行される関数
  def computer_guessing
    puts "Computer's turn! Enter the number the computer expects to see!"
    @answer = input_players_number
    number = 0
    hit = 0
    brow = 0
    index = 0
    possible_numbers = nil
    loop do
      @computer_turn_count += 1
      # コンピュータがランダムな四桁の数字を生成
      if hit + brow == 4
        possible_numbers = combination_of_item(number.split('')) if index.zero?

        number = possible_numbers[index]
        index += 1
      else
        number = generate_numbers(computer_turn_count, number, hit, brow)
      end
      puts "Computer chose #{number}"
      # 正解の場合ループを抜ける
      if number == answer
        puts 'Computer selected correct number!'
        break
      end
      if computer_turn_count == 12
        puts '12 turns have passed. Computer turn is finished!'
        break
      end
      # answerが変更されないようコピー
      answer_copy = answer.split('')
      # その数字のヒットとブローを出す
      hit = calc_hit_count(number.split(''), answer_copy)
      brow = calc_brow_count(number.split(''), answer_copy)
      puts "#{hit} hits #{brow} brow"
    end
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

game = Game.new('Player 1')
game.play
