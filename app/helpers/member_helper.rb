#coding:utf-8
module MemberHelper

	  # 高亮搜索结果
  def search_result_highlight(hit, field)
    field = field.to_sym
    if highlight = hit.highlight(field)
      raw highlight.format { |word| 
      	"<span class='highlight'>#{word}</span>" 
      }
    else
      content = hit.result.send(field)
    end
  end

  def highlight_hit(hit)
  	if highlight = hit.highlight(:body)
      raw highlight.format { |word| "<span class='highlight'>#{word}</span>" }   
    elsif highlight = hit.highlight(:comments)
      raw highlight.format { |word| "<span class='highlight'>#{word}</span>" } 
    elsif highlight = hit.highlight(:title) 
      hit.result.send(:title)
    elsif highlight = hit.highlight(:topic_member) 
      body = highlight.format { |word| "<span class='highlight'>#{word}</span>" } 
      raw "<font color='green'>发贴人</font>: #{body} "
    elsif highlight = hit.highlight(:comments_member)
      body = highlight.format { |word| "<span class='highlight'>#{word}</span>" } 
      raw "<font color='green'>评论人</font>: #{body}"
    end
  end

end
