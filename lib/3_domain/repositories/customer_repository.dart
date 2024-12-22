import 'package:dartz/dartz.dart';

import '../../failures/failures.dart';
import '../models/models.dart';

abstract class CustomerRepository {
  Future<Either<AbstractFailure, Customer>> createCustomer(Customer customer);
  Future<Either<AbstractFailure, Customer>> getCustomerById(String customerId);
  Future<Either<AbstractFailure, ({List<Customer> customers, int totalCount})>> getCustomers({
    required String searchTerm,
    required int itemsPerPage,
    required int currentPage,
  });
  Future<Either<AbstractFailure, Customer>> updateCustomer(Customer customer);
  Future<Either<AbstractFailure, Unit>> deleteCustomers(List<String> customerIds);
}
