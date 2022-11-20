
#Область ПрограммныйИнтерфейс

// Функция возвращает признак, определяющий возможность редактирования цен в документах
// пользователю, для которого установлен профиль "Продажи". 
//
Функция РазрешеноРедактированиеЦенДокументов() Экспорт
	
	Если ЕстьПрофильРабочееМестоКассира() И НЕ РольДоступна("ДобавлениеИзменениеПодсистемыПродажи") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если РольДоступна("ДобавлениеИзменениеПодсистемыПродажи") И НЕ РольДоступна("РедактированиеЦенДокументов") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

// Функция - Это полноправный пользователь
// 
// Возвращаемое значение:
//  Булево - признак наличия полных прав
//
Функция ЭтоПолноправныйПользователь() Экспорт
	
	Возврат РольДоступна("ПолныеПрава");
	
КонецФункции

// Функция возвращает признак, определяющий наличие права текущего пользователя к объекту метаданных
//
// Параметры:
//  Право			 - Строка	 - проверяемое право
//  ИдентификаторОбъектаМетаданных - СправочникСсылка.ИдентификаторыОбъектовМетаданных,
//      СправочникСсылка.ИдентификаторыОбъектовРасширений - идентификатор проверяемого объекта
// 
// Возвращаемое значение:
//  Булево - право доступа текущего пользователя к объекту метаданных
//
Функция ЕстьПравоДоступа(Право, ИдентификаторОбъектаМетаданных) Экспорт
	
	Возврат ПравоДоступа(Право, ОбщегоНазначения.ОбъектМетаданныхПоИдентификатору(ИдентификаторОбъектаМетаданных));
	
КонецФункции

// Проверяет, что в группах доступах пользователя есть профиль Рабочее место кассира
//
Функция ЕстьПрофильРабочееМестоКассира(ОпределяемыйПользователь = Неопределено) Экспорт
	
	Если ОпределяемыйПользователь = Неопределено Тогда
		ОпределяемыйПользователь = Пользователи.ТекущийПользователь();
	КонецЕсли;
	
	ГуидПрофиляРМК = УправлениеДоступомУНФ.ПрофильРабочееМестоКассира().УИД;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ГруппыДоступаПользователи.Ссылка
	|ИЗ
	|	Справочник.ГруппыДоступа.Пользователи КАК ГруппыДоступаПользователи
	|ГДЕ
	|	ГруппыДоступаПользователи.Пользователь = &Пользователь
	|	И ГруппыДоступаПользователи.Ссылка.Профиль.ИдентификаторПоставляемыхДанных = &ГуидПрофиляРМК");
	
	Запрос.УстановитьПараметр("Пользователь", ОпределяемыйПользователь);
	Запрос.УстановитьПараметр("ГуидПрофиляРМК", ГуидПрофиляРМК);
	
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат НЕ Запрос.Выполнить().Пустой();
	
КонецФункции

Функция ЕстьПравоНастройкиЭДО() Экспорт
	
	ЕстьПраво = Пользователи.РолиДоступны("ДобавлениеИзменениеНастроекОбменаСКонтрагентами");
	
	Возврат ЕстьПраво;
		
КонецФункции


#КонецОбласти
