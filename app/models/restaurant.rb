class Restaurant < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :name, presence: true, uniqueness: true
  validates :category, presence: true
  # mount_uploader :image, ImageUploader
  enum category: [:寿司, :魚料理, :和食, :ラーメン・麺類, :お好み焼き・粉物, :日本料理・郷土料理, :アジア・エスニック, :中華, :イタリアン, :洋食・西洋料理, :フレンチ, :アメリカ料理, :珍しい各国料理, :焼肉・ステーキ, :焼き鳥・串料理, :しゃぶしゃぶ・すき焼き, :カフェ・スイーツ, :ビュッフェ・バイキング, :居酒屋・バー, :ファミレス, :ファストフード, :その他]
  has_one :place
  has_many :cuisines
end
