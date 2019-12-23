import { NativeModules, processColor } from 'react-native';
const Bio = NativeModules.FingerprintAuth;

export default {
  isSupported() {
    return new Promise((resolve, reject) => {
      Bio.isSupported(
        error => {
          return reject(typeof error == 'String' ? createError(error, error) : createError(error));
        },
        success => {
          return resolve(true);
        }
      );
    });
  },

  authenticate(reason, config) {
    DEFAULT_CONFIG = { title: 'Authentication Required', color: '#1306ff' };
    var authReason = reason ? reason : ' ';
    var authConfig = config ? config : DEFAULT_CONFIG;
    var color = processColor(authConfig.color);

    authConfig.color = color;

    return new Promise((resolve, reject) => {
      Bio.authenticate(
        authReason,
        authConfig,
        error => {
          return reject(typeof error == 'String' ? createError(error, error) : createError(error));
        },
        success => {
          return resolve(true);
        }
      );
    });
  }
};

function TouchIDError(name, details) {
  this.name = name || 'TouchIDError';
  this.message = details.message || 'Touch ID Error';
  this.details = details || {};
}

TouchIDError.prototype = Object.create(Error.prototype);
TouchIDError.prototype.constructor = TouchIDError;

function createError(error) {
  return new TouchIDError('Touch ID Error', error);
}
