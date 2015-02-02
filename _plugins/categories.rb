module Jekyll

    class CategoryPage < Page
        def initialize(site, base, dir, category)
            @site = site
            @base = base
            @dir = dir
            @name = 'index.html'

            self.process(@name)
            self.read_yaml(File.join(base, '_layouts'), 'category.html')
            self.data['category'] = category

            category_title_prefix = site.config['category_title_prefix'] || ''
            category_title_postfix = site.config['category_title_prefix'] || ''
            self.data['title'] = "#{category_title_prefix}#{category}#{category_title_postfix}"
        end
    end

    class CategoryPageGenerator < Generator
        safe true

        def generate(site)
            if site.layouts.key? 'category'
                dir = site.config['category_dir'] || 'categories'
                site.categories.each_key do |category|
                    @cp = CategoryPage.new(site, site.source, File.join(dir, category), category)
                    site.pages << @cp
                end
            end
        end
    end

end
