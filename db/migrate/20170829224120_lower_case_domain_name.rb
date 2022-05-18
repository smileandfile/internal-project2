class LowerCaseDomainName < ActiveRecord::Migration[5.0]
  def up
    @domains = Domain.where.not("upper(domains.name) = 'CODERBHA'").where.not("UPPER(domains.name) = 'GSANDBOX'")
    @domains.each do |key, value|
      # Keep one and return rest of the duplicate records
      duplicates = Domain.where("lower(domains.name) = '#{key.name}'")
      puts "#{key} = #{duplicates.count}"
      duplicates.destroy_all
    end
    enable_extension :citext
    change_column :domains, :name, :citext
  end

  def down
    change_column :domains, :name, :string
  end
end
