atom_feed do |feed|
  feed.title(app_name + " Forum - Topic " + @topic.name)
  feed.updated(@topic.cb_post.first.created_at)

  for post in @topic.cb_post
    feed.entry(post, :url => cb_forum_cb_topic_cb_post_url(@cb_forum, @topic)) do |entry|
      entry.title(@topic.name + ' - Comment ' + post.id.to_s)
      entry.content(post.body, :type => 'html')

      entry.author do |author|
        author.name(post.person.name)
      end
    end
  end
end