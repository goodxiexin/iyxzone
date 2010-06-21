class RegionFactory

  def self.create cond={}
    Factory.create :region, cond
  end

end

class CityFactory
  
  def self.create cond={}
    if cond[:region_id].blank?
      cond[:region_id] = RegionFactory.create.id
    end
    Factory.create :city, cond
  end

end

class DistrictFactory

  def self.create cond={}
    if cond[:city_id].blank?
      cond[:city_id] = CityFactory.create.id
    end
    Factory.create :district, cond
  end

end
