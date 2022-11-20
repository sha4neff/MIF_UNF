
#Область ПрограммныйИнтерфейс

// Функция - Коэффициент единицы
//
// Параметры:
//  ЕдиницаИзмерения - СправочникСсылка.ЕдиницыИзмерения
// 
// Возвращаемое значение:
//  Число - Коэффициент пересчета в базовую единицу измерения номенклатурной позиции
//
Функция КоэффициентЕдиницы(ЕдиницаИзмерения) Экспорт
	
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЕдиницаИзмерения, "Коэффициент");
	
КонецФункции

#КонецОбласти