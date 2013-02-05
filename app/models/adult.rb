class Adult < User
  def sub_units
    scout_ids = self.scouts.select('"users"."id"').all
    SubUnit.joins(:scouts).where(users: {id: scout_ids} )
  end
end
