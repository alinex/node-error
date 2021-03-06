// Generated by CoffeeScript 1.7.1
(function() {
  module.exports.returnString = function() {
    return "Something went wrong";
  };

  module.exports.returnError = function() {
    return new Error("Something went wrong");
  };

  module.exports.returnCause = function() {
    var err;
    err = new Error("Something went wrong");
    err.cause = new Error("root fault");
    err.codePart = 'somethere';
    return err;
  };

  module.exports.returnCauseArray = function() {
    var err;
    err = new Error("Something went wrong");
    err.cause = [new Error("root fault 1"), new Error("root fault 2")];
    err.codePart = 'somethere';
    return err;
  };

  module.exports.returnCauseHash = function() {
    var err;
    err = new Error("Something went wrong");
    err.cause = {
      here: new Error("root fault 1"),
      there: new Error("root fault 2")
    };
    return err;
  };

}).call(this);

//# sourceMappingURL=object.map
