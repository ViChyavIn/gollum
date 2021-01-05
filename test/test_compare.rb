# ~*~ encoding: utf-8 ~*~
require File.expand_path(File.join(File.dirname(__FILE__), 'helper'))
require File.expand_path '../../lib/gollum/views/commit', __FILE__

def get_commit_diff(sha1)
  commit = @wiki.repo.commit(sha1)
  @wiki.repo.diff(commit.parent.id, sha1)
end

context "Precious::Views::Compare" do
  setup do
    @path    = cloned_testpath('examples/lotr.git')
    # Precious::App.set(:gollum_path, @path)
    @wiki = Gollum::Wiki.new(@path)
  end

  test 'file addition diff' do
    view = Precious::Views::Compare.new
    diff = get_commit_diff 'fbabba862dfa7ac35b39042dd4ad780c9f67b8cb'
    view.instance_variable_set(:@diff, diff)

    assert_equal [
      {:line=>"@@ -0,0 +1 @@", :class=>"gc", :ldln=>"...", :rdln=>"..."},
      {:line=>"+# Eye Of Sauron", :class=>"gi", :ldln=>" ", :rdln=>"1"}
    ], view.lines
  end

  test 'empty file addition diff' do
    view = Precious::Views::Compare.new
    diff = get_commit_diff '181c757cca395d4da18701d069a6b8123e88e040'
    view.instance_variable_set(:@diff, diff)

    assert_equal [], view.lines
  end

  test 'binary file addition diff' do
    view = Precious::Views::Compare.new
    diff = get_commit_diff 'afe2034d400ba21e13361f38f74900c51dbc7fde'
    view.instance_variable_set(:@diff, diff)

    assert_equal [{
      :line=>"Binary files /dev/null and b/Mordor/eye.jpg differ",
      :class=>"gg", :ldln=>"...", :rdln=>"..."
    }], view.lines
  end
end
