xml.instruct! :xml, :version=>"1.0"
xml.rss(:version=>"2.0") {
	xml.channel {
		xml.title(@blog.title)  
		xml.link(url_for(:only_path => false))
		xml.description(@blog.subtitle)
		xml.language('en-us')  
		@posts.each do |post|
			xml.item do  
				 xml.title(post.title || '')  
				 xml.link(blog_named_link(post))
				 xml.description(post.body)  
				 xml.tag(post.tag_string)  
				 xml.posted_by(post.posted_by.user_name)  
			 end  
		 end  
	}
}