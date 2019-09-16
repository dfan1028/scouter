Fabricator(:product) do
  ext_id { SecureRandom.hex(8) }
end
