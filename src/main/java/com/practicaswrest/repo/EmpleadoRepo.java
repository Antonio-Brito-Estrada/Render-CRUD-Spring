
package com.practicaswrest.repo;

import com.practicaswrest.entity.Empleado;
import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
// import org.springframework.data.jpa.repository.query.Procedure;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface EmpleadoRepo extends JpaRepository<Empleado, Integer>{
    // Querys JPA 
    //no se pueden utilizar los metos CRUD de esta forma porque ya estan 
    //incluidos en JPA y fallan por la redundancia
    @Query("SELECT e FROM Empleado e ORDER BY e.nombres")
    List<Empleado> findAllOrderByNombre();
    
    // Querys Nativas 
    @Query(value="SELECT * FROM Empleado ORDER BY codigo", nativeQuery = true)
    List<Empleado> findAllOrderByCodigo();
    //funciona
    //@Query(value="SELECT * FROM Empleado WHERE nombres LIKE %:filtro%", nativeQuery = true)
    @Query(value="SELECT * FROM Empleado WHERE UPPER(nombres) LIKE UPPER(CONCAT('%', :filtro, '%'))", nativeQuery = true)
    List<Empleado> findByNombre(@Param("filtro") String filtro);
    
    @Query(value = "SELECT say_hello()", nativeQuery = true)
    String createUser();

    // @Query(value = "DELETE FROM Empleado WHERE codigo = :codigo", nativeQuery = true)
    // void deleteByCodigo(@Param("codigo") Integer codigo);
    void deleteByCodigo(Integer codigo);

    // @Query("SELECT e FROM Empleado e WHERE codigo = :codigo")
    // Optional<Empleado> getByCodigo(@Param("codigo") Integer codigo);
    @Query(value = "SELECT * FROM Empleado WHERE codigo = :codigo",  nativeQuery = true)
    Optional<Empleado> getByCodigo(@Param("codigo") Integer codigo);
}
