import '../model/master/master_data.dart';
import '../model/master/point_master.dart';
import '../model/repository/repository_result.dart';
import 'api/open_api_provider.dart';
import 'base/base_repository.dart';
import 'memory_cache/memory_cache.dart';

class MasterRepository extends BaseRepository {
  final OpenApiProvider _openApiProvider = OpenApiProvider();

  static MemoryCache<MasterData> _inquiryCache = MemoryCache();
  static MemoryCache<MasterData> _prefectureCache = MemoryCache();
  static MemoryCache<MasterData> _heightCache = MemoryCache();
  static MemoryCache<MasterData> _animalCache = MemoryCache();
  static MemoryCache<MasterData> _jobCache = MemoryCache();
  static MemoryCache<MasterData> _holidayCache = MemoryCache();
  static MemoryCache<MasterData> _hobbyCache = MemoryCache();
  static MemoryCache<MasterData> _bloodCache = MemoryCache();
  static MemoryCache<PointMaster> _pointCache =
      MemoryCache.fromCacheValidateTime(15 * 60 * 1000);

  Future<RepositoryResult<List<MasterData>>> getInquiryMaster() async {
    List<MasterData>? cache = _inquiryCache.getListData();
    if (cache == null) {
      final result = await apiResponseToRepositoryResult(
          _openApiProvider.getInquiryMaster());
      if (result is RepositorySuccessResult) {
        _inquiryCache.saveListData((result as RepositorySuccessResult).data);
      }
      return result;
    }
    return RepositoryResult.success(cache, null);
  }

  Future<RepositoryResult<List<MasterData>>> getPrefectureMaster() async {
    List<MasterData>? cache = _prefectureCache.getListData();
    if (cache == null) {
      final result = await apiResponseToRepositoryResult(
          _openApiProvider.getPrefectureMaster());
      if (result is RepositorySuccessResult) {
        _prefectureCache.saveListData((result as RepositorySuccessResult).data);
      }
      return result;
    }
    return RepositoryResult.success(cache, null);
  }

  Future<RepositoryResult<List<MasterData>>> getHeightMaster() async {
    List<MasterData>? cache = _heightCache.getListData();
    if (cache == null) {
      final result = await apiResponseToRepositoryResult(
          _openApiProvider.getHeightMaster());
      if (result is RepositorySuccessResult) {
        _heightCache.saveListData((result as RepositorySuccessResult).data);
      }
      return result;
    }
    return RepositoryResult.success(cache, null);
  }

  Future<RepositoryResult<List<MasterData>>> getAnimalMaster() async {
    List<MasterData>? cache = _animalCache.getListData();
    if (cache == null) {
      final result = await apiResponseToRepositoryResult(
          _openApiProvider.getAnimalMaster());
      if (result is RepositorySuccessResult) {
        _animalCache.saveListData((result as RepositorySuccessResult).data);
      }
      return result;
    }
    return RepositoryResult.success(cache, null);
  }

  Future<RepositoryResult<List<MasterData>>> getJobMaster() async {
    List<MasterData>? cache = _jobCache.getListData();
    if (cache == null) {
      final result =
          await apiResponseToRepositoryResult(_openApiProvider.getJobMaster());
      if (result is RepositorySuccessResult) {
        _jobCache.saveListData((result as RepositorySuccessResult).data);
      }
      return result;
    }
    return RepositoryResult.success(cache, null);
  }

  Future<RepositoryResult<List<MasterData>>> getHolidayMaster() async {
    List<MasterData>? cache = _holidayCache.getListData();
    if (cache == null) {
      final result = await apiResponseToRepositoryResult(
          _openApiProvider.getHolidayMaster());
      if (result is RepositorySuccessResult) {
        _holidayCache.saveListData((result as RepositorySuccessResult).data);
      }
      return result;
    }
    return RepositoryResult.success(cache, null);
  }

  Future<RepositoryResult<List<MasterData>>> getHobbyMaster() async {
    List<MasterData>? cache = _hobbyCache.getListData();
    if (cache == null) {
      final result = await apiResponseToRepositoryResult(
          _openApiProvider.getHobbyMaster());
      if (result is RepositorySuccessResult) {
        _hobbyCache.saveListData((result as RepositorySuccessResult).data);
      }
      return result;
    }
    return RepositoryResult.success(cache, null);
  }

  Future<RepositoryResult<List<MasterData>>> getBloodMaster() async {
    List<MasterData>? cache = _bloodCache.getListData();
    if (cache == null) {
      final result = await apiResponseToRepositoryResult(
          _openApiProvider.getBloodMaster());
      if (result is RepositorySuccessResult) {
        _bloodCache.saveListData((result as RepositorySuccessResult).data);
      }
      return result;
    }
    return RepositoryResult.success(cache, null);
  }

  Future<RepositoryResult<List<PointMaster>>> getPointMaster() async {
    List<PointMaster>? cache = _pointCache.getListData();
    if (cache == null) {
      final result = await apiResponseToRepositoryResult(
          _openApiProvider.getPointMaster());
      if (result is RepositorySuccessResult) {
        _pointCache.saveListData((result as RepositorySuccessResult).data);
      }
      return result;
    }
    return RepositoryResult.success(cache, null);
  }
}
