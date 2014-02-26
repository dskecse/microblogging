shared_examples_for 'all static pages' do
  it { should have_selector('h1', text: heading) }
  it { should have_title(full_title(page_title)) }
end
