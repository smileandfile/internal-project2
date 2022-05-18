class PopulatingRolesTable < ActiveRecord::Migration[5.0]
  def up
    r = Role.create(name: "gstn1")
    Role.create(name: "Prepare and Save data", parent_id: r.id, allowed_actions: ["gstn1#return_status", "gstn1#save_invoices"])
    Role.create(name: "Get data", parent_id: r.id, allowed_actions: ["gstn1#B2BA_invoices", "gstn1#CDNR_invoices", "gstn1#B2B_invoices", "gstn1#B2CL_invoices",
      "gstn1#B2CS_invoices", "gstn1#nil_rated", "gstn1#exp", "gstn1#at", "gstn1#hsn_summary", "gstn1#txp", "gstn1#cdnur", "gstn1#doc_issued"])
    Role.create(name: "File", parent_id: r.id, allowed_actions: ["gstn1#file_gstr1", "gstn1#file_details"])
    Role.create(name: "Submit data", parent_id: r.id, allowed_actions: ["gstn1#submit_gstr1"])
  end

  def down
    Role.delete_all
  end
end
