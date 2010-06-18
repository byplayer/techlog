# -*- coding: utf-8 -*-
require File.expand_path('../acceptance_helper', __FILE__)

feature '基本設定の利用' do
	background do
		setup_tdiary
	end

	scenario 'サイトの情報の設定' do
		visit '/'
		click '追記'
		click '設定'
		click 'サイトの情報'
		fill_in "author_name", :with => "ただただし"
		fill_in "html_title", :with => "ただの日記"
		fill_in "author_mail", :with => "t@tdtds.jp"
		fill_in "index_page", :with => "http://www.example.com"
		fill_in "description", :with => "ただただしによる日々の記録"
		fill_in "icon", :with => "http://tdtds.jp/favicon.png"
		# TODO banner の値が fill_in されない
		#fill_in "banner", :with => "http://sho.tdiary.net/images/banner.png"

		click_button "OK"
		within('title') { page.should have_content('(設定完了)') }

		click '最新'
		# TODO その他の項目の反映を確認
		within('title') { page.should have_content('ただの日記') }

		click '追記'
		click '設定'
		click 'サイトの情報'
		page.should have_field "author_name", :with => "ただただし"
		page.should have_field "html_title", :with => "ただの日記"
		page.should have_field "author_mail", :with => "t@tdtds.jp"
		page.should have_field "index_page", :with => "http://www.example.com"
		page.should have_field "description", :with => "ただただしによる日々の記録"
		page.should have_field "icon", :with => "http://tdtds.jp/favicon.png"
		# TODO banner の値が fill_in されない
		# page.should have_field("banner", :with => "http://sho.tdiary.net/images/banner.png")
	end

	scenario 'ヘッダ・フッタの設定' do
		visit '/'
		click '追記'
		click '設定'
		click 'ヘッダ・フッタ'
		fill_in "header", :with => <<-HEADER
<%= navi %>
<h1>alpha</h1>
<div class="main">
HEADER
		fill_in "footer", :with => <<-FOOTER
</div>
<div class="sidebar">
bravo
</div>
FOOTER

		click_button "OK"
		within('title') { page.should have_content('(設定完了)') }

		click '最新'
		within('h1') { page.should have_content('alpha') }
		within('div.sidebar') { page.should have_content('bravo')}

		click '追記'
		click '設定'
		click 'ヘッダ・フッタ'
		page.should have_field "header", :with => <<-HEADER
<%= navi %>
<h1>alpha</h1>
<div class="main">
HEADER
		page.should have_field "footer", :with => <<-FOOTER
</div>
<div class="sidebar">
bravo
</div>
FOOTER
	end

	scenario '表示一版の設定' do
		visit '/'
		click '追記'
		click '設定'
		click '表示一般'
		fill_in 'section_anchor', :with => <<-SECTION
<span class="sanchor">■</span>
SECTION
		fill_in 'comment_anchor', :with => <<-COMMENT
<span class="canchor">#</span>
COMMENT
		fill_in 'date_format', :with => <<-DATE
%Y/%m/%d
DATE
		fill_in 'latest_limit', :with => 1
		select '非表示', :from => 'show_nyear'

		click_button "OK"
		within('title') { page.should have_content('(設定完了)') }

	end

	scenario 'ログレベルの選択の設定' do
		visit '/'
		click '追記'
		click '設定'
		click 'ログレベル選択'
		select 'DEBUG', :from => 'log_level'

		click_button "OK"
		within('title') { page.should have_content('(設定完了)') }

		click '最新'
		# TODO ログレベルの確認

		click '追記'
		click '設定'
		click 'ログレベル選択'
		within('select option[selected]'){
			page.should have_content 'DEBUG'
		}
	end

	scenario '時差調整が保存される' do
		visit '/'
		click '追記'
		click '設定'
		click '時差調整'
		fill_in 'hour_offset', :with => '-24'

		click_button "OK"
		within('title') { page.should have_content('(設定完了)') }

		click '追記'
		y, m, d = (Date.today - 1).to_s.split('-').map {|t| t.sub(/^0+/, "") }
		within('div.day div.form') {
			within('span.year') { page.should have_field('year', :with => y) }
			within('span.month') { page.should have_field('month', :with => m) }
			within('span.day') { page.should have_field('day', :with => d) }
		}

		click '設定'
		click '時差調整'

		page.should have_field('hour_offset', :with => '-24.0')
	end

	scenario 'テーマ選択が保存される' do
		visit '/'
		click '追記'
		click '設定'
		click 'テーマ選択'
		select 'Tdiary1', :from => 'theme'

		click_button "OK"
		within('title') { page.should have_content('(設定完了)') }

		click '最新'
		within('head') {
			page.should have_css('link[href="theme/base.css"]')
		}

		click '追記'
		click '設定'
		click 'テーマ選択'
		within('select option[selected]'){
			page.should have_content 'Tdiary1'
		}
	end
end
