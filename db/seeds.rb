# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

if User.count <= 0
  u = User.new email: 'super@coderbhai.com', password: 'Coderbhai123',
                role: :super, name: 'Coderbhai super'
  u.save!
end

packages = [
  # ["Only Filing of Form GSTR -3B (for the months of July and August 2017)",
  #  0,
  #  99,
  #  'Money Back guarantee – 15 days.',
  #  18
  # ],

  # ["Subscription Charges for a Composition dealer",
  #   1,
  #   999,
  #   "Book in advance. Rates will rise later.",
  #   18
  # ],

  ["Subscription charges for a Normal Tax Payer for filing of all the GST returns",
    2,
    750,
    "3 Months additional subscription if you select a half yearly or annual package.
    For eg for half yearly plan you will get 9 months validity and for an annual
    plan you will get 15 months validity.",
    18
  ]
]

packages.each do |name, type, cost, description, expiry|
  if Package.where(package_type: type).first.present?
    Package.where(package_type: type).first.update_attributes(name: name,
                                                              package_type: type,
                                                              cost: cost,
                                                              description: description,
                                                              expiry_duration_months: expiry)
  else
    Package.create!(name: name,
                    package_type: type,
                    cost: cost,
                    description: description,
                    expiry_duration_months: expiry)
  end
end

package = Package.where(package_type: :normal_tax_payer).first
package_id = package.id

sub_packages = [
  [1, 50_00_000, 1750, 1100, 600, package_id],
  [50_00_000, 1_00_00_000, 2250, 1300, 700, package_id],
  [1_00_00_000, 1_50_00_000, 3500, 2100, 1100, package_id],
  [1_50_00_000, 2_00_00_000, 5000, 2900, 1500, package_id],
  [2_00_00_000, 5_00_00_000, 8500, 4900, 2500, package_id],
  [5_00_00_000, 10_00_00_000, 12500, 7200, 3600, package_id],
  [10_00_00_000, 25_00_00_000, 17500, 10100, 5100, package_id],
  [25_00_00_000, 50_00_00_000, 21000, 12100, 6100, package_id],
  [500000000, 1000000000, 32500, 18700, 9400, package_id],
  [1000000000, 1500000000, 45000, 25900, 13000, package_id],
  [1500000000, 2000000000, 55000, 31700, 15900, package_id],
  [2000000000, 3000000000, 75000, 43200, 21600, package_id],
  [3000000000, 4000000000, 100000, 57500, 28800, package_id],
  [4000000000, 5000000000, 125000, 71900, 36000, package_id],
  [5000000000, 7000000000, 160000, 92000, 46000, package_id],
  [7000000000, 10000000000, 200000, 115000, 57500, package_id],
  [10000000000, 15000000000, 250000, 143800, 71900, package_id],
  [15000000000, nil, 300000, 172500, 86280, package_id]
]
if (package.sub_packages.count <= 0)
  sub_packages.each do |from, to, annual, half_yearly, quarterly, package_id|
    SubPackage.create!(turnover_from: from, turnover_to: to,
      annual: annual, half_yearly: half_yearly, quarterly: quarterly,
      package_id: package_id)
  end
end

if Role.count <= 0

  r0 = Role.new name: "All Actions", parent_id: nil
  r0.save
  r1 = Role.new name: "gstn1", parent_id: r1.id
  r1.save
  r2 = Role.new name: "Submit data", parent_id: r1.id
  r2.save
  r3 = Role.new name: "File", parent_id: r1.id
  r3.save
  r4 = Role.new name: "Get data", parent_id: r1.id
  r4.save
  r5 = Role.new name: "Prepare and Save data", parent_id: r1.id
  r5.save
end
if SnfSetting.count <= 0
  s = SnfSetting.new
  s.gstin_number = "27AABCS4052Q1ZY"
  s.save
end 