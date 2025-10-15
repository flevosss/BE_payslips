# Load request statuses and leave types from config file
config = YAML.load_file(Rails.root.join('config', 'request_statuses.yml'))

REQUEST_STATUSES = config['request_statuses'].with_indifferent_access
LEAVE_TYPES = config['leave_types'].with_indifferent_access

