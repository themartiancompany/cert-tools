const
  _path =
    require(
      'path');
const
  _output_dir =
    _path.resolve(
      __dirname);
const
  _input_file_name =
    `libcert-gen`;
const
  _input_file_path =
    `./${_input_file_name}`;
const
  _output_file_name =
    `${_input_file_name}.js`;
const
  _node_fs_ignore = {
    resourceRegExp:
      /^node:fs$/
};
const
  _yargs_ignore =
  { resourceRegExp:
      /^yargs$/ };
const
  _yargs_helpers_ignore = {
    resourceRegExp:
      /^yargs\/helpers$/
};
const
  _webpack =
    require(
     "webpack");
const
  _ignore_plugin =
    _webpack.IgnorePlugin; 
const
  _node_fs_ignore_plugin =
    new _ignore_plugin(
          _node_fs_ignore);
const
  _yargs_ignore_plugin =
    new _ignore_plugin(
          _yargs_ignore);
const
  _yargs_helpers_ignore_plugin =
    new _ignore_plugin(
          _yargs_helpers_ignore);
const
  _output = {
    path:
      _output_dir,
    filename:
      _output_file_name
};
module.exports = {
  entry:
    _input_file_path,
  output:
    _output,
  optimization: {
    moduleIds: 'deterministic',
  },
  resolve: {
    alias: {
      "fs":
        _path.resolve(
          __dirname,
          'node_modules/fs/fs'),
      "path":
        _path.resolve(
          __dirname,
          'node_modules/path/mod.js'),
    },
    fallback: {
      "utils":
        false,
      "web-worker":
        false,
      "yargs":
        false,
      "yargs/helpers":
        false,
    }
  },
  externals:
    { yargs:
        'yargs' },
  plugins: [
    _node_fs_ignore_plugin,
    _yargs_ignore_plugin,
    _yargs_helpers_ignore_plugin
  ]
};
