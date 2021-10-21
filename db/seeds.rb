# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
user = User.new(
  :name => 'staff',
  :email => 'staff1@gmail.com',
  :phone => '08012345678',
  :password => '12345678',
  :staff => true
)
user.skip_confirmation!
user.save!

# faq = Faq.new(
#   :faqtype => '予約・チェックインについて',
#   :title => 'キャンセル料金の取り扱いについて',
#   :content => '前日の正午から100%キャンセル料を頂戴しています。
#   但し、各プラン及び店舗ごとで異なる場合がありますのでご確認ください。'
# )

# faq.save!

Faq.create!(
  [
    {
      faqtype: '予約・チェックインについて',
      title: 'キャンセル料金の取り扱いについて',
      content: '前日の正午から100%キャンセル料を頂戴しています。
      但し、各プラン及び店舗ごとで異なる場合がありますのでご確認ください。'
    },
    {
      faqtype: '予約・チェックインについて',
      title: 'クレジットカードは、どこのブランドが使えますか？',
      content: '現在対応しているカードは「VISA」と「マスターカード」がご利用いただけます。'
    },
    {
      faqtype: '予約・チェックインについて',
      title: 'チェックアウトの時間をずらすことはできますか？',
      content: 'チェックアウトの時間をずらすことはできません。
      但し、延長は2時間まで可能です。（1,000円/時間）
      直接、お電話（098-988-1952）でお問い合わせください。。'
    },
    {
      faqtype: '予約・チェックインについて',
      title: 'チェックインは何時まで可能ですか？',
      content: '16:00以降は自由チェックインです。'
    },
    {
      faqtype: '予約・チェックインについて',
      title: '台風で飛行機が飛びませんでした。キャンセルできますか？',
      content: 'キャンセル料は無料です。'
    },

    {
      faqtype: '設備について',
      title: 'アパートメントホテルって何ですか？',
      content: '素泊まりに特化したコンドミニアムタイプの宿です。
      フロントスタッフは常駐しておりません。
      
      何かお困りのことがございましたら、
      お電話（098-988-1952）にてお問い合わせください。'
    },
    {
      faqtype: '設備について',
      title: 'アメニティは何がありますか？',
      content: '歯ブラシ、髭剃り、ボディスポンジ、ヘアブラシ、シャンプー、リンス、ボディシャンプー、ハンドソープがあります。上記のアメニティはシャワールームの鏡の裏に置いてあります。'
    },
    {
      faqtype: '設備について',
      title: 'エクストラベッドはありますか？',
      content: 'ありません。'
    },
    {
      faqtype: '設備について',
      title: 'タオルはありますか？',
      content: '16:あります。
      バスタオル、フェイスタオル、足マットをご用意しております。'
    },
    {
      faqtype: '設備について',
      title: 'ランドリーはありますか？',
      content: 'はい、室内に洗濯機と乾燥機を完備しており、無料でご利用いただけます。
      ちなみに、洗剤も無料でついております。
      
      ただし、ホテルコンシェル宜野湾バイパスは部屋に乾燥機はありません。
      2Fにランドリー室がございます。'
    },
    {
      faqtype: '連泊のお客様へ',
      title: '清掃スケジュールについて教えてください。',
      content: '清掃スケジュール例です。
      清掃が不要なお客様は、お電話（098-988-1952）にてお問い合わせください。'
    }
  ]
)
