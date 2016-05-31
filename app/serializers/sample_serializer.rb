[SampleSerializer,SampleSerializer::Level10].each do |klass|
  klass.class_eval do
  #include Labeled
    attributes :tags

    def tags
      if t=Scifinding::Tag.where(molecule_id: molecule.id).last
        tag_scifinder={count: t.count,updated: t.updated_at.to_date}
        {scifinder: tag_scifinder}
      end
    end

  end

end
