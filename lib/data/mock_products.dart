import '../models/product_model.dart';

final List<Product> mockProducts = [
  Product(
    id: 1,
    name: 'Basic Oversize T-Shirt',
    description:
        'Soft cotton oversized t-shirt for daily wear, easy to style with jeans or skirts.',
    price: 249000,
    image:
        'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=1200&auto=format&fit=crop',
    imageGallery: [
      'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=1200&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1583743814966-8936f5b7be1a?w=1200&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1523381210434-271e8be1f52b?w=1200&auto=format&fit=crop',
    ],
    color: 'Black',
    quantity: 40,
    category: 'THOI_TRANG',
    originalPrice: 299000,
    discountPercent: 17,
    availableSizes: ['S', 'M', 'L', 'XL'],
    availableColors: ['White', 'Black', 'Gray'],
    detailSpecs: {
      'Material': '100% Cotton',
      'Fit': 'Oversize',
      'Style': 'Casual',
    },
  ),
  Product(
    id: 2,
    name: 'Linen Long Sleeve Shirt',
    description:
        'Breathable linen shirt for office and weekend wear with a clean premium look.',
    price: 389000,
    image:
        'https://images.unsplash.com/photo-1603252109303-2751441dd157?w=1200&auto=format&fit=crop',
    imageGallery: [
      'https://images.unsplash.com/photo-1603252109303-2751441dd157?w=1200&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1594938298603-c8148c4dae35?w=1200&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1617127365659-c47fa864d8bc?w=1200&auto=format&fit=crop',
    ],
    color: 'Beige',
    quantity: 28,
    category: 'THOI_TRANG',
    originalPrice: 449000,
    discountPercent: 13,
    availableSizes: ['M', 'L', 'XL'],
    availableColors: ['White', 'Light Blue', 'Beige'],
    detailSpecs: {
      'Material': 'Linen blend',
      'Collar': 'Classic',
      'Sleeve': 'Long',
    },
  ),
  Product(
    id: 3,
    name: 'Straight Leg Jeans',
    description:
        'Mid-rise straight jeans with light stretch for comfort and balanced silhouette.',
    price: 479000,
    image:
        'https://images.unsplash.com/photo-1541099649105-f69ad21f3246?w=1200&auto=format&fit=crop',
    imageGallery: [
      'https://images.unsplash.com/photo-1541099649105-f69ad21f3246?w=1200&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1473966968600-fa801b869a1a?w=1200&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1475178626620-a4d074967452?w=1200&auto=format&fit=crop',
    ],
    color: 'Denim Blue',
    quantity: 35,
    category: 'THOI_TRANG',
    originalPrice: 559000,
    discountPercent: 14,
    availableSizes: ['28', '29', '30', '31', '32'],
    availableColors: ['Denim Blue', 'Black'],
    detailSpecs: {
      'Material': 'Stretch denim',
      'Leg': 'Straight',
      'Thickness': 'Medium',
    },
  ),
  Product(
    id: 4,
    name: 'Pleated Midi Skirt',
    description:
        'A-line pleated midi skirt with smooth movement and elegant daily-office style.',
    price: 429000,
    image:
        'https://images.unsplash.com/photo-1583496661160-fb5886a13d77?w=1200&auto=format&fit=crop',
    imageGallery: [
      'https://images.unsplash.com/photo-1583496661160-fb5886a13d77?w=1200&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1581044777550-4cfa60707c03?w=1200&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1619603364904-c0498317e145?w=1200&auto=format&fit=crop',
    ],
    color: 'Cream',
    quantity: 22,
    category: 'THOI_TRANG',
    originalPrice: 499000,
    discountPercent: 14,
    availableSizes: ['S', 'M', 'L'],
    availableColors: ['Cream', 'Black', 'Brown'],
    detailSpecs: {
      'Material': 'Chiffon with lining',
      'Silhouette': 'A-line',
      'Length': 'Midi',
    },
  ),
  Product(
    id: 5,
    name: 'Light Bomber Jacket',
    description:
        'Lightweight bomber jacket for transitional weather and sporty smart outfits.',
    price: 649000,
    image:
        'https://images.unsplash.com/photo-1521223890158-f9f7c3d5d504?w=1200&auto=format&fit=crop',
    imageGallery: [
      'https://images.unsplash.com/photo-1521223890158-f9f7c3d5d504?w=1200&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=1200&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=1200&auto=format&fit=crop',
    ],
    color: 'Olive',
    quantity: 16,
    category: 'THOI_TRANG',
    originalPrice: 749000,
    discountPercent: 13,
    availableSizes: ['M', 'L', 'XL'],
    availableColors: ['Black', 'Olive', 'Cream'],
    detailSpecs: {
      'Material': 'Polyester',
      'Style': 'Bomber',
      'Lining': 'Light lining',
    },
  ),
  Product(
    id: 6,
    name: 'Puff Sleeve Midi Dress',
    description:
        'Feminine midi dress with puff sleeves and a balanced waist shape for many occasions.',
    price: 719000,
    image:
        'https://images.unsplash.com/photo-1496747611176-843222e1e57c?w=1200&auto=format&fit=crop',
    imageGallery: [
      'https://images.unsplash.com/photo-1496747611176-843222e1e57c?w=1200&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1464863979621-258859e62245?w=1200&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1529139574466-a303027c1d8b?w=1200&auto=format&fit=crop',
    ],
    color: 'Dark Red',
    quantity: 19,
    category: 'THOI_TRANG',
    originalPrice: 819000,
    discountPercent: 12,
    availableSizes: ['S', 'M', 'L'],
    availableColors: ['Dark Red', 'Black', 'Beige'],
    detailSpecs: {
      'Material': 'Matte satin',
      'Length': 'Midi',
      'Sleeve': 'Puff sleeve',
    },
  ),
  Product(
    id: 7,
    name: 'Mini Shoulder Bag',
    description:
        'Compact shoulder bag with clean shape for workday and weekend city use.',
    price: 559000,
    image:
        'https://images.unsplash.com/photo-1594223274512-ad4803739b7c?w=1200&auto=format&fit=crop',
    imageGallery: [
      'https://images.unsplash.com/photo-1594223274512-ad4803739b7c?w=1200&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=1200&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1614179689702-355944cd0918?w=1200&auto=format&fit=crop',
    ],
    color: 'Brown',
    quantity: 18,
    category: 'PHU_KIEN',
    originalPrice: 639000,
    discountPercent: 13,
    availableSizes: ['One Size'],
    availableColors: ['Black', 'Brown', 'Beige'],
    detailSpecs: {
      'Material': 'PU leather',
      'Carry': 'Shoulder',
      'Compartments': '2 main compartments',
    },
  ),
  Product(
    id: 8,
    name: 'Zip Clutch Wallet',
    description:
        'Slim wallet with practical card and cash organization in a compact footprint.',
    price: 299000,
    image:
        'https://images.unsplash.com/photo-1627123424574-724758594e93?w=1200&auto=format&fit=crop',
    imageGallery: [
      'https://images.unsplash.com/photo-1627123424574-724758594e93?w=1200&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1612198188060-c7c2a3b66eae?w=1200&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1556740749-887f6717d7e4?w=1200&auto=format&fit=crop',
    ],
    color: 'Black',
    quantity: 30,
    category: 'PHU_KIEN',
    originalPrice: 349000,
    discountPercent: 14,
    availableSizes: ['One Size'],
    availableColors: ['Black', 'Brown'],
    detailSpecs: {
      'Material': 'Synthetic leather',
      'Closure': 'Metal zipper',
      'Card Slots': '8',
    },
  ),
  Product(
    id: 9,
    name: 'Square Frame Sunglasses',
    description:
        'Modern square sunglasses with UV protection for outdoor daily styling.',
    price: 359000,
    image:
        'https://images.unsplash.com/photo-1511499767150-a48a237f0083?w=1200&auto=format&fit=crop',
    imageGallery: [
      'https://images.unsplash.com/photo-1511499767150-a48a237f0083?w=1200&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1492707892479-7bc8d5a4ee93?w=1200&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1577803645773-f96470509666?w=1200&auto=format&fit=crop',
    ],
    color: 'Black',
    quantity: 24,
    category: 'PHU_KIEN',
    originalPrice: 419000,
    discountPercent: 14,
    availableSizes: ['One Size'],
    availableColors: ['Black', 'Brown', 'Clear'],
    detailSpecs: {'UV': 'UV400', 'Frame': 'Acetate', 'Shape': 'Square'},
  ),
  Product(
    id: 10,
    name: 'Embroidered Baseball Cap',
    description:
        'Structured baseball cap with adjustable buckle for casual street outfits.',
    price: 219000,
    image:
        'https://images.unsplash.com/photo-1521369909029-2afed882baee?w=1200&auto=format&fit=crop',
    imageGallery: [
      'https://images.unsplash.com/photo-1521369909029-2afed882baee?w=1200&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1534215754734-18e55d13e346?w=1200&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1514327605112-b887c0e61c0a?w=1200&auto=format&fit=crop',
    ],
    color: 'Navy',
    quantity: 33,
    category: 'PHU_KIEN',
    originalPrice: 259000,
    discountPercent: 15,
    availableSizes: ['One Size'],
    availableColors: ['Black', 'White', 'Navy'],
    detailSpecs: {
      'Material': 'Cotton twill',
      'Lock': 'Metal buckle',
      'Style': 'Streetwear',
    },
  ),
  Product(
    id: 11,
    name: 'Metal Strap Watch',
    description:
        'Minimal metal strap watch for clean, polished finishing to your outfit.',
    price: 990000,
    image:
        'https://images.unsplash.com/photo-1522312346375-d1a52e2b99b3?w=1200&auto=format&fit=crop',
    imageGallery: [
      'https://images.unsplash.com/photo-1522312346375-d1a52e2b99b3?w=1200&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1508057198894-247b23fe5ade?w=1200&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1434056886845-dac89ffe9b56?w=1200&auto=format&fit=crop',
    ],
    color: 'Silver',
    quantity: 14,
    category: 'PHU_KIEN',
    originalPrice: 1150000,
    discountPercent: 14,
    availableSizes: ['One Size'],
    availableColors: ['Silver', 'Black'],
    detailSpecs: {
      'Case': '40 mm',
      'Strap': 'Stainless steel',
      'Water Resistance': '3 ATM',
    },
  ),
  Product(
    id: 12,
    name: 'Slim Leather Belt',
    description:
        'Slim leather belt with durable buckle, easy to pair with jeans and trousers.',
    price: 279000,
    image:
        'https://images.unsplash.com/photo-1624222247344-550fb60583dc?w=1200&auto=format&fit=crop',
    imageGallery: [
      'https://images.unsplash.com/photo-1624222247344-550fb60583dc?w=1200&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1617127365659-c47fa864d8bc?w=1200&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1589756823695-278bc923f962?w=1200&auto=format&fit=crop',
    ],
    color: 'Brown',
    quantity: 26,
    category: 'PHU_KIEN',
    originalPrice: 329000,
    discountPercent: 15,
    availableSizes: ['90', '95', '100', '105'],
    availableColors: ['Black', 'Brown'],
    detailSpecs: {
      'Material': 'Leather',
      'Width': '2.8 cm',
      'Buckle': 'Pin buckle',
    },
  ),
];
