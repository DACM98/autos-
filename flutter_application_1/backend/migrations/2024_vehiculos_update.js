'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    // Agregar campos imagen y valorAlquiler a la tabla vehiculos
    await queryInterface.addColumn('vehiculos', 'imagen', {
      type: Sequelize.STRING,
      allowNull: true,
      comment: 'URL de la imagen del vehículo'
    });

    await queryInterface.addColumn('vehiculos', 'valorAlquiler', {
      type: Sequelize.DECIMAL(10, 2),
      allowNull: false,
      defaultValue: 0.00,
      comment: 'Valor del alquiler por día'
    });
  },

  async down(queryInterface, Sequelize) {
    // Revertir cambios - eliminar las columnas agregadas
    await queryInterface.removeColumn('vehiculos', 'imagen');
    await queryInterface.removeColumn('vehiculos', 'valorAlquiler');
  }
};
