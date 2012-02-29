module Magazine
  class CommentsController < ApplicationController

    magazine_authenticate :except => [:create]
    magazine_sweeper(:create, :update, :destroy)

    helper 'magazine/articles'

    def create
      @comment = article.comments.build(params[:magazine_comment])

      if @comment.valid?
        status_message = current_user.build_post( :status_message,
                                { :public => true,
                                  :text => comment_blog_post_message_status_update_text(current_user.person, @comment)
                                })
        status_message.skip_formatting = true

        if status_message.save
          current_user.add_to_streams(status_message, current_user.aspects)
          current_user.dispatch_post(status_message, :url => short_post_url(status_message.guid))
        end
      end

      respond_to do |format|

        format.js

        format.html do
          if @comment.save
            redirect_to article, :notice => "Successfully added comment!"
          else
            render "magazine/articles/show"
          end
        end
      end

    end

    def destroy
      @comment = article.comments.find(params[:id])
      @comment.destroy
      respond_to do |format|
        format.html { redirect_to(article, :notice => "Successfully removed comment.") }        
        format.js
      end
    end

    private

    def article
      @article ||= Magazine::Article.find(params[:magazine_article_id])
    end

    def comment_blog_post_message_status_update_text(person, comment)
      tag = "<a href='#{person_path(person)}'>#{person.messaging_name}</a>"
      tag += " commented on "
      tag += "<a href='#{magazine_article_path(comment.article)}'>#{comment.article.title}</a>"
      tag += "<span class='body-comment-magazine-post-message-status'> : \"#{comment.body}\"</span>"
      tag
    end
  end
end
