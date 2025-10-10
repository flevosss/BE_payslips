# Load departments from config file
DEPARTMENTS = YAML.load_file(Rails.root.join('config', 'departments.yml'))['departments']

