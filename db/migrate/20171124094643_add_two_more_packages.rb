class AddTwoMorePackages < ActiveRecord::Migration[5.1]
  def change
    p1 = Package.new
    p1.name = "GST Suvidha Kendra"
    p1.package_type = :gst_suvidha_kendra
    p1.description = "Credit for number of GSTIN's : 0 [against the annual subscription]" \
                     " Subscription to be charged against each GSTIN created : Rs 150/- + 18% GST." \
                     " This amount is to be deducted against the deposit of Rs 5000/-." \
                     " You can add money to deposit account by topping up."
    p1.cost = "5000"
    p1.expiry_duration_months = 12
    p1.save                 

    p1 = Package.new
    p1.name = "Professionals and Tax advisers:"
    p1.package_type = :professionals_and_tax_advisers
    p1.description = "Credit for number of GSTIN's : 50 [against the annual subscription]" \
                     " Subscription to be charged against each GSTIN created : After 50 GSTIN's : Rs 200/- + 18% GST." \
                     " This amount is to be deducted against the deposit" \
                     " You can add money to deposit account by topping up."
    p1.cost = "10000"
    p1.expiry_duration_months = 12
    p1.save

  end
end
