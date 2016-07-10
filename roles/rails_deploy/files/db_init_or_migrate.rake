namespace :db do
  task :init_or_migrate => [:environment, :load_config] do
    if !ActiveRecord::SchemaMigration.table_exists?
      Rake::Task["db:setup"].invoke
    else
      Rake::Task["db:migrate"].invoke
    end
  end
end
