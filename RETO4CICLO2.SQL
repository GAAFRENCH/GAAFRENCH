package controller;

import model.vo.MaterialNacional;
import model.dao.MaterialNacionalDao;

import model.vo.ProyectoRankeadoCompras;
import model.dao.ProyectoRankeadoComprasDao;

import model.vo.CargoAsignacion;
import model.dao.CargoAsignacionDao;

import java.sql.SQLException;
import java.util.ArrayList;

public class ControladorRequerimientosReto4 {

    private final MaterialNacionalDao materialNacionalDao;
    private final ProyectoRankeadoComprasDao proyectoRankeadoComprasDao;
    private final CargoAsignacionDao cargoAsignacionDao;

    public ControladorRequerimientosReto4(){
        this.materialNacionalDao = new MaterialNacionalDao();
        this.proyectoRankeadoComprasDao = new ProyectoRankeadoComprasDao();
        this.cargoAsignacionDao = new CargoAsignacionDao();
    }

    public ArrayList<MaterialNacional> consultarMaterialesNacionalesComprados() throws SQLException {
        return this.materialNacionalDao.topMaterialesNacionales();
    }

    public ArrayList<ProyectoRankeadoCompras> consultarProyectosComprasGranito() throws SQLException {
        return this.proyectoRankeadoComprasDao.topProyectosComprasGranito();
    }

    public ArrayList<CargoAsignacion> consultarCargosMenosAsignados() throws SQLException {
        return this.cargoAsignacionDao.cargosMenosAsignados();
    }    


}
package model.dao;

import java.util.ArrayList;

import util.JDBCUtilities;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.ResultSet;

import model.vo.CargoAsignacion;


public class CargoAsignacionDao {

    //Requerimiento 5 Reto 3

    //Los dos cargos que tienen menos proyectos asignados
    public ArrayList<CargoAsignacion> cargosMenosAsignados() throws SQLException {

        //Preparar la colección que tendrá la respuesta
        ArrayList<CargoAsignacion> respuesta = new ArrayList<CargoAsignacion>();

        //Declarar la conexión
        Connection conexion = null;

        //Intentar conectarnos y extraer la información de la base de datos para el requerimiento
        //Lógica -> Consulta SQL
        try{

            //Conectarse
            conexion = JDBCUtilities.getConnection();

            String consulta = "SELECT l.Cargo, "+
                                        "COUNT (p.ID_Proyecto) AS Numero_Proyectos "+
                                "FROM Proyecto p "+
                                "JOIN Lider l ON "+
                                "p.ID_Lider = l.ID_Lider "+
                                "GROUP BY l.Cargo "+
                                "ORDER BY Numero_Proyectos "+
                                "LIMIT 2 ";

            //Construir objeto que realizará la consulta
            PreparedStatement statement = conexion.prepareStatement(consulta);

            //Realizar propiamente la consulta
            ResultSet resultSet = statement.executeQuery();

            //Recorrerlo mientras tenga posiciones, o registros
            while(resultSet.next()){                
                CargoAsignacion cargo = new CargoAsignacion();
                cargo.setCargo(resultSet.getString("Cargo"));
                cargo.setNoProyectos(resultSet.getInt("Numero_Proyectos"));            

                respuesta.add(cargo);
            }

            resultSet.close();
            statement.close();


        }catch(SQLException e){
            System.err.println("Error consultando cargos menos asignado!! " + e);

        }finally{
            if(conexion != null){
                conexion.close();
            }
        }

        //Retornar la colección de materiales de producción nacional
        return respuesta;

    }

}
package model.dao;

import java.util.ArrayList;

import util.JDBCUtilities;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.ResultSet;

import model.vo.MaterialNacional;


public class MaterialNacionalDao {

    //Requerimiento 3 Reto 3

    //Materiales de producción nacional más comprados
    public ArrayList<MaterialNacional> topMaterialesNacionales() throws SQLException {

        //Preparar la colección que tendrá la respuesta
        ArrayList<MaterialNacional> respuesta = new ArrayList<MaterialNacional>();

        //Declarar la conexión
        Connection conexion = null;

        //Intentar conectarnos y extraer la información de la base de datos para el requerimiento
        //Lógica -> Consulta SQL
        try{

            //Conectarse
            conexion = JDBCUtilities.getConnection();

            String consulta = "SELECT  m.Nombre_Material,"+
                                        "m.Importado, "+
                                        "COUNT(*) as No_Compras "+
                                "FROM MaterialConstruccion as m "+
                                "INNER JOIN Compra c "+
                                "ON m.ID_MaterialConstruccion = c.ID_MaterialConstruccion "+
                                "WHERE m.Importado = 'No' "+
                                "GROUP BY m.ID_MaterialConstruccion "+
                                "ORDER BY No_Compras DESC, "+
                                        "m.Nombre_Material ASC ";

            //Construir objeto que realizará la consulta
            PreparedStatement statement = conexion.prepareStatement(consulta);

            //Realizar propiamente la consulta
            ResultSet resultSet = statement.executeQuery();

            //Recorrerlo mientras tenga posiciones, o registros
            while(resultSet.next()){                
                MaterialNacional material = new MaterialNacional();
                material.setNombreMaterial(resultSet.getString("Nombre_Material"));
                material.setImportado(resultSet.getString(2));
                //material.setImportado(resultSet.getString("Importado"));
                material.setNoCompras(resultSet.getInt("No_Compras"));

                respuesta.add(material);
            }

            resultSet.close();
            statement.close();


        }catch(SQLException e){
            System.err.println("Error consultando ranking de materiales nacionales!! " + e);

        }finally{
            if(conexion != null){
                conexion.close();
            }
        }

        //Retornar la colección de materiales de producción nacional
        return respuesta;

    } 




}
