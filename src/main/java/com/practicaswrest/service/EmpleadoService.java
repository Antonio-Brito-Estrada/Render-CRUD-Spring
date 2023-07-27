
package com.practicaswrest.service;

import com.practicaswrest.entity.Empleado;
import com.practicaswrest.repo.EmpleadoRepo;
import java.util.List;
import java.util.Optional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class EmpleadoService{
    
    @Autowired
    private EmpleadoRepo empleadorepo;
    
    public Empleado insertar(Empleado emp){
        return empleadorepo.save(emp);
    }
    
    public Empleado actualizar(Empleado emp){
        return empleadorepo.save(emp);
    }
    
    public List<Empleado> listar(){
        return empleadorepo.findAll();
    }
    
    public Optional<Empleado> findById(int id){
        return empleadorepo.findById(id);
    }
    
    public void eliminar(int id){
        empleadorepo.deleteById(id);
    }
    
    public List<Empleado> findAllOrderByNombre(){
        return empleadorepo.findAllOrderByNombre();
    }
    
    public List<Empleado> findAllOrderByCodigo(){
        return empleadorepo.findAllOrderByCodigo();
    }
    
    public List<Empleado> findByNombre(String filtro){
        return empleadorepo.findByNombre(filtro);
    }
    
    public String createUser() {
       return empleadorepo.createUser();
    }
    
// Aqui empiezan los nuevos servicios
    @Transactional
    public void deleteByCodigo(Integer codigo){
        empleadorepo.deleteByCodigo(codigo);
    }

    public Optional<Empleado> getByCodigo(Integer codigo){
        return empleadorepo.getByCodigo(codigo);
    }
}
