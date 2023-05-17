# Categorias
first_category = Category.create!(name: "Eletrônicos")
second_category = Category.create!(name: "Cozinha")
third_category = Category.create!(name: "Vestuário")
fourth_category = Category.create!(name: "Livros")
fifth_category = Category.create!(name: "Esportes")

# Produtos
first_product = ProductModel.create!(
  name: "Monitor LG",
  description: "Monitor de 32 polegadas da marca LG...",
  weight: 1500,
  width: 100,
  height: 80,
  depth: 15,
  category: first_category,
  photo: Rack::Test::UploadedFile.new("#{Rails.root}/app/assets/images/products/monitor-lg.webp", "image/webp"),
)
second_product = ProductModel.create!(
  name: "Smartphone Samsung",
  description: "Smartphone Samsung Galaxy S21 com tela de 6.2 polegadas...",
  weight: 200,
  width: 7,
  height: 15,
  depth: 8,
  category: first_category,
  photo: Rack::Test::UploadedFile.new("#{Rails.root}/app/assets/images/products/smart-sam.webp", "image/webp"),
)
third_product = ProductModel.create!(
  name: "Notebook Dell",
  description: "Notebook Dell Inspiron 15 com processador Intel Core i5...",
  weight: 2000,
  width: 36,
  height: 2,
  depth: 24,
  category: first_category,
  photo: Rack::Test::UploadedFile.new("#{Rails.root}/app/assets/images/products/note-dell.webp", "image/webp"),
)
fourth_product = ProductModel.create!(
  name: "Smartwatch Apple",
  description: "Smartwatch Apple Watch Series 6 com caixa de 44mm...",
  weight: 47,
  width: 3,
  height: 4,
  depth: 1,
  category: first_category,
  photo: Rack::Test::UploadedFile.new("#{Rails.root}/app/assets/images/products/smart-watch.webp", "image/webp"),
)
fifth_product = ProductModel.create!(
  name: "Câmera Sony",
  description: "Câmera Sony Alpha a7 III com sensor full-frame de 24.2 MP...",
  weight: 650,
  width: 13,
  height: 11,
  depth: 7,
  category: first_category,
  photo: Rack::Test::UploadedFile.new("#{Rails.root}/app/assets/images/products/sony-cam.webp", "image/webp"),
)
sixth_product = ProductModel.create!(
  name: "Caixa de som JBL",
  description: "Caixa de som JBL Xtreme 2 com Bluetooth e bateria de 10.000 mAh...",
  weight: 2393,
  width: 13,
  height: 28,
  depth: 13,
  category: first_category,
)
seventh_product = ProductModel.create!(
  name: "Forno Elétrico",
  description: "Forno Elétrico de Bancada Oster 10L com Timer...",
  weight: 4500,
  width: 35,
  height: 20,
  depth: 28,
  category: second_category,
)
eighth_product = ProductModel.create!(
  name: "Jaqueta de Couro",
  description: "Jaqueta de Couro Masculina com Zíper Lateral...",
  weight: 1000,
  width: 50,
  height: 5,
  depth: 70,
  category: third_category,
)
ninth_product = ProductModel.create!(
  name: "Livro - O Senhor dos Anéis",
  description: "A história narra o conflito contra o mal que se alastra pela Terra-média...",
  weight: 800,
  width: 15,
  height: 23,
  depth: 2,
  category: fourth_category,
)
tenth_product = ProductModel.create!(
  name: "Bicicleta",
  description: "Bicicleta de Montanha MTB Aro 29 com 21 Marchas...",
  weight: 15000,
  width: 75,
  height: 140,
  depth: 20,
  category: fifth_category,
)
eleventh_product = ProductModel.create!(
  name: "Smartphone Samsung",
  description: "Smartphone Samsung Galaxy S21 com Tela de 6.2 Polegadas e Câmera Tripla...",
  weight: 170,
  width: 7,
  height: 15,
  depth: 2,
  category: first_category,
)
twelfth_product = ProductModel.create!(
  name: "Mixer 3 em 1",
  description: "Mixer 3 em 1 Oster com Triturador, Batedor e Processador de Alimentos...",
  weight: 1500,
  width: 9,
  height: 37,
  depth: 9,
  category: second_category,
)
thirteenth_product = ProductModel.create!(
  name: "Wetsuit",
  description: "O novo wetsuit Apex Float é a roupa de borracha mais flutuante da gama Orca...",
  weight: 300,
  width: 30,
  height: 40,
  depth: 3,
  category: third_category,
)
fourteenth_product = ProductModel.create!(
  name: "Livro de Ficção",
  description: "Livro de Ficção - As Crônicas de Gelo e Fogo: A Guerra dos Tronos...",
  weight: 950,
  width: 16,
  height: 23,
  depth: 6,
  category: fourth_category,
)
fifteenth_product = ProductModel.create!(
  name: "Bola de Futebol",
  description: "Bola de Futebol Penalty Max 500 VIII...",
  weight: 400,
  width: 22,
  height: 22,
  depth: 22,
  category: fifth_category,
)

# Usuários regulares
first_user = User.create!(
  email: "felipe@gmail.com",
  cpf: "70587229004",
  password: "123123",
)
second_user = User.create!(
  email: "maria@gmail.com",
  cpf: "39889813033",
  password: "123123",
)

# Admins
first_admin = User.create!(
  email: "maria@leilaodogalpao.com.br",
  cpf: "03507869098",
  password: "123123",
)
second_admin = User.create!(
  email: "fernando@leilaodogalpao.com.br",
  cpf: "64063418057",
  password: "123123",
)
third_admin = User.create!(
  email: "carlos@leilaodogalpao.com.br",
  cpf: "90334708028",
  password: "123123",
)

# Lotes
first_lot = Lot.create!(
  batch_code: "ELE661430",
  start_date: 1.second.from_now,
  end_date: 1.hour.from_now,
  min_value: 2500,
  min_allowed_difference: 35,
  register_by_id: first_admin.id,
  approved_by_id: second_admin.id,
)
first_lot.product_models << second_product
first_lot.product_models << eleventh_product
first_lot.update!(status: :approved)

second_lot = Lot.create!(
  batch_code: "FTH123456",
  start_date: 3.minutes.from_now,
  end_date: 11.hours.from_now,
  min_value: 1500,
  min_allowed_difference: 25,
  register_by_id: first_admin.id,
  approved_by_id: third_admin.id,
)
second_lot.product_models << ninth_product
second_lot.product_models << fourteenth_product
second_lot.update!(status: :approved)

Lot.create!(
  batch_code: "LMP654321",
  start_date: 1.day.from_now,
  end_date: 2.days.from_now,
  min_value: 500,
  min_allowed_difference: 5,
  register_by_id: first_admin.id,
)
third_lot = Lot.create!(
  batch_code: "QWE987654",
  start_date: 1.second.from_now,
  end_date: 1.minute.from_now,
  min_value: 2200,
  min_allowed_difference: 100,
  register_by_id: second_admin.id,
  approved_by_id: third_admin.id,
)
third_lot.product_models << fifteenth_product
third_lot.update!(start_date: 1.minute.ago)
third_lot.update!(status: :approved)
Bid.create!(user: first_user, lot: third_lot, amount: 120)
Bid.create!(user: second_user, lot: third_lot, amount: 120)
Bid.create!(user: first_user, lot: third_lot, amount: 200)
third_lot.update!(status: :ended)

fourth_lot = Lot.create!(
  batch_code: "UIO234567",
  start_date: 1.second.from_now,
  end_date: 8.hours.from_now,
  min_value: 1200,
  min_allowed_difference: 20,
  register_by_id: second_admin.id,
  approved_by_id: first_admin.id,
)
fourth_lot.product_models << first_product
fourth_lot.product_models << third_product
fourth_lot.product_models << fourth_product
fourth_lot.update!(status: :approved)

fifth_lot = Lot.create!(
  batch_code: "RTY456789",
  start_date: 1.day.from_now,
  end_date: 2.days.from_now,
  min_value: 1500,
  min_allowed_difference: 75,
  register_by_id: first_admin.id,
  approved_by_id: second_admin.id,
)
fifth_lot.product_models << thirteenth_product
third_lot.update!(start_date: 1.minute.ago)
third_lot.update!(status: :approved)
third_lot.update!(status: :ended)

sixth_lot = Lot.create!(
  batch_code: "QAZ987654",
  start_date: 1.day.from_now,
  end_date: 2.days.from_now,
  min_value: 1500,
  min_allowed_difference: 75,
  register_by_id: first_admin.id,
  approved_by_id: second_admin.id,
)
sixth_lot.product_models << sixth_product
sixth_lot.update!(status: :approved)
