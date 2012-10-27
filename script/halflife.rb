require 'rufus/scheduler'
scheduler = Rufus::Scheduler.start_new

scheduler.every("1d") do
  Topic.where("viewpoint>0").each do |topic|
    p topic.title
    topic.viewpoint /= 2
    topic.save
  end
  
end

scheduler.join