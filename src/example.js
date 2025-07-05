/**
 * Example JavaScript file for demonstrating Gemini CLI integration
 * This file showcases various JavaScript patterns that could be documented
 * using Google's Gemini CLI or API.
 */

/**
 * A simple class to demonstrate object-oriented programming concepts
 * @class
 */
class DocumentationExample {
  /**
   * Creates an instance of DocumentationExample
   * @param {string} name - The name of the example
   * @param {string} description - Description of what this example does
   */
  constructor(name, description) {
    this.name = name;
    this.description = description;
    this.createdAt = new Date();
  }

  /**
   * Returns a greeting message
   * @returns {string} A personalized greeting
   */
  greet() {
    return `Hello from ${this.name}! ${this.description}`;
  }

  /**
   * Updates the description of this example
   * @param {string} newDescription - The new description
   * @returns {boolean} Success status
   */
  updateDescription(newDescription) {
    if (typeof newDescription !== 'string' || newDescription.length === 0) {
      return false;
    }
    this.description = newDescription;
    return true;
  }

  /**
   * Gets the age of this example in milliseconds
   * @returns {number} Age in milliseconds
   */
  getAge() {
    return Date.now() - this.createdAt.getTime();
  }
}

/**
 * Utility function to format timestamps
 * @param {Date} date - The date to format
 * @returns {string} Formatted date string
 */
function formatDate(date) {
  return date.toISOString().split('T')[0];
}

/**
 * Async function to simulate API calls
 * @param {string} endpoint - The API endpoint
 * @param {Object} options - Request options
 * @returns {Promise<Object>} Promise resolving to response data
 */
async function fetchData(endpoint, options = {}) {
  // Simulate API delay
  await new Promise(resolve => setTimeout(resolve, 100));
  
  return {
    success: true,
    data: `Data from ${endpoint}`,
    timestamp: new Date().toISOString(),
    options
  };
}

/**
 * Configuration object for the application
 * @typedef {Object} AppConfig
 * @property {string} apiUrl - Base URL for API calls
 * @property {number} timeout - Request timeout in milliseconds
 * @property {boolean} debug - Enable debug mode
 */

/**
 * Default configuration
 * @type {AppConfig}
 */
const DEFAULT_CONFIG = {
  apiUrl: 'https://api.example.com',
  timeout: 5000,
  debug: false
};

// Export for use in other modules
module.exports = {
  DocumentationExample,
  formatDate,
  fetchData,
  DEFAULT_CONFIG
}; 